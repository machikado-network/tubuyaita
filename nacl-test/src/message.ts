import nacl_util from "tweetnacl-util";
import nacl from "tweetnacl";
import ed2curve from "ed2curve";

type Signed<T> = string
type Encrypted<T> = string


interface Message {
    publicKey: string
    contents: Signed<(Content | EncryptedContents) & Timestamp> // <- これが文字列になってる
    sign: string
}


interface Timestamp {
    timestamp: number // UTC Timestamp (Date.now())
}

interface Content {
    body: string
    retweet?: Retweet
}

interface EncryptedContents {
    contents: EncryptedContent[]
}

interface EncryptedContent {
    content: Encrypted<Content> // Encrypted
    receiverPublicKey: string
    nonce: string
}

interface Retweet {
    host: string // 10.50.12.1とかsyamimomo.d.mchkd.netとか
    port: number // 80とか
    id: string // {Request}から作られたhash
}

const decodeUtf8 = (s: Uint8Array) => Buffer.from(s).toString("hex")
const encodeUtf8 = (s: string) => Buffer.from(s, "hex")


// 二人の鍵を生成
const {publicKey: alicePublicKey, secretKey: aliceSecretKey} = nacl.sign.keyPair()
const {publicKey: bobPublicKey, secretKey: bobSecretKey} = nacl.sign.keyPair()

// ------ Alice ------

// Aliceは自分のX25519秘密鍵とBobのX25519公開鍵を作る
const aliceX25519SecretKey = ed2curve.convertSecretKey(aliceSecretKey)
const bobX25519PublicKey = ed2curve.convertPublicKey(bobPublicKey)


const nonce = nacl.randomBytes(24)
// AliceのX25519秘密鍵でContentを暗号化
const raw_content: Content = {
    body: "Hello, It's private message from alice to bob"
}
const encryptedContent: Encrypted<Content> = decodeUtf8(nacl.box(new TextEncoder().encode(JSON.stringify(raw_content)), nonce, bobX25519PublicKey!, aliceX25519SecretKey))


const content: EncryptedContent = {
    content: encryptedContent,
    receiverPublicKey: decodeUtf8(bobPublicKey),
    nonce: decodeUtf8(nonce),
}


const contents: EncryptedContents & Timestamp = {
    contents: [content],
    timestamp: Date.now()
}


const send_message: Message & Timestamp = {
    publicKey: decodeUtf8(alicePublicKey),
    contents: JSON.stringify(contents),
    timestamp: Date.now(),
    sign: decodeUtf8(nacl.sign(nacl.hash(new TextEncoder().encode(JSON.stringify([content]))), aliceSecretKey)),
}

console.log("Sending message:")
console.log(send_message)
console.log()

const httpBody = JSON.stringify(send_message)


// ----- Bob ------
// Bobは自分の秘密鍵から自分のX25519秘密鍵を作る
const bobX25519SecretKey = ed2curve.convertSecretKey(bobSecretKey)


const message: Message & Timestamp = JSON.parse(httpBody)

// 本当にAliceからきたか確かめる
console.assert(nacl.sign.open(encodeUtf8(message.sign), alicePublicKey) !== null)

const receivedEncryptedContents: EncryptedContents & Timestamp = JSON.parse(message.contents)

const receivedEncryptedContent = receivedEncryptedContents.contents[0]

// BobはBobのX25519秘密鍵とAliceのX25519公開鍵を使って解錠する

// BobはAliceから送られてきた公開鍵からAliceのX25519公開鍵を作る
const aliceX25519PublicKey = ed2curve.convertPublicKey(encodeUtf8(message.publicKey))

// 解読する
const decryptedMessage = nacl.box.open(encodeUtf8(receivedEncryptedContent.content), encodeUtf8(receivedEncryptedContent.nonce), aliceX25519PublicKey!, bobX25519SecretKey)

const realContent = nacl_util.encodeUTF8(decryptedMessage!)

console.log(realContent)
