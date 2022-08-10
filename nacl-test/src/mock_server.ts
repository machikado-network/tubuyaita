import express from "express"
import {Message} from "./types";
import nacl from "tweetnacl";
import assert from "assert";
const encodeUtf8 = (s: string) => Buffer.from(s, "hex")
const decodeUtf8 = (s: Uint8Array) => Buffer.from(s).toString("hex")


const app = express()
app.use(express.json())

const port = 8000

let messages: {[p: string]: Message} = {}

app.get('/', (req, res) => {
    res.send('Hello World!')
})

app.post('/api/v0/messages', (req, res) => {
    const message: Message = req.body

    // verify sign by using message.publicKey
    const hash = nacl.sign.open(encodeUtf8(message.sign), encodeUtf8(message.publicKey))
    const expected_hash = nacl.hash(Buffer.from(message.contents))

    // Check hask is same
    assert(decodeUtf8(hash!) === decodeUtf8(expected_hash))

    messages[decodeUtf8(hash!)] = message

    res.send("Created").status(201)
})

app.listen(port, () => {
    console.log(`app listening on port ${port}`)
})
