import nacl from "tweetnacl";
import nacl_util from "tweetnacl-util"
import ed2curve from "ed2curve"

const {publicKey: alicePublicKey, secretKey: aliceSecretKey} = nacl.sign.keyPair()
const {publicKey: bobPublicKey, secretKey: bobSecretKey} = nacl.sign.keyPair()


// BobとAliceのX25519鍵を作る
const aliceDHPublicKey = ed2curve.convertPublicKey(alicePublicKey)
const aliceDHSecretKey = ed2curve.convertSecretKey(aliceSecretKey)
const bobDHPublicKey = ed2curve.convertPublicKey(bobPublicKey)
const bobDHSecretKey = ed2curve.convertSecretKey(bobSecretKey)

const nonce = nacl.randomBytes(24)

// Alice -> Bobにメッセージを送る
// AliceのDH秘密鍵とBobのDH公開鍵を使う
const message = nacl_util.decodeUTF8("No matter what")
const encryptedMessage = nacl.box(message, nonce, bobDHPublicKey!, aliceDHSecretKey)

console.log(nonce)
console.log(encryptedMessage.toString())

// BobはBobのDH秘密鍵とAliceのDH公開鍵を使って解錠する
const decryptedMessage = nacl.box.open(encryptedMessage, nonce, aliceDHPublicKey!, bobDHSecretKey)

console.log(nacl_util.encodeUTF8(decryptedMessage!))
