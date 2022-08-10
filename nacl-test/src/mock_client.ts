import nacl from "tweetnacl";
import ed2curve from "ed2curve";
import {Content, Encrypted, EncryptedContent, EncryptedContents, Message, Timestamp} from "./types";
const decodeUtf8 = (s: Uint8Array) => Buffer.from(s).toString("hex")


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
const stringedContents = JSON.stringify(contents)


const send_message: Message & Timestamp = {
    publicKey: decodeUtf8(alicePublicKey),
    contents: stringedContents,
    timestamp: Date.now(),
    sign: decodeUtf8(nacl.sign(nacl.hash(Buffer.from(stringedContents)), aliceSecretKey)),
}

console.log("Sending message:")
console.log(send_message)
console.log()

const httpBody = JSON.stringify(send_message)

const send = async () => {
    const response = await fetch("http://127.0.0.1:8000/api/v0/messages", {
        method: "POST",
        body: httpBody,
        headers: [
            ["Content-Type", "application/json"]
        ]
    })
    console.log(response.status)
    console.log(await response.text())
}

send().catch(console.error)
