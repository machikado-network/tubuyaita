export type Signed<T> = string
export type Encrypted<T> = string


export interface Message {
    publicKey: string
    contents: Signed<(Content | EncryptedContents) & Timestamp> // <- これが文字列になってる
    sign: string
}


export interface Timestamp {
    timestamp: number // UTC Timestamp (Date.now())
}

export interface Content {
    body: string
    retweet?: Retweet
}

export interface EncryptedContents {
    contents: EncryptedContent[]
}

export interface EncryptedContent {
    content: Encrypted<Content> // Encrypted
    receiverPublicKey: string
    nonce: string
}

export interface Retweet {
    host: string // 10.50.12.1とかsyamimomo.d.mchkd.netとか
    port: number // 80とか
    id: string // {Request}から作られたhash
}
