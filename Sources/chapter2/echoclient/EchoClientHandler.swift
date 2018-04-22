import NIO

// Listing 2.3 ChannelHandler for the client

public class EchoClientHandler: ChannelInboundHandler {
    public typealias InboundIn = ByteBuffer
    public typealias OutboundOut = ByteBuffer
    public typealias InboundOut = String
    
    var readBuffer: ByteBuffer?
    
    public func channelActive(ctx: ChannelHandlerContext) {
        let message = "Netty rocks!"
        var byteBuffer = ctx.channel.allocator.buffer(capacity: message.utf8.count)
        byteBuffer.write(string: message)
        readBuffer = ctx.channel.allocator.buffer(capacity: message.utf8.count)
        ctx.writeAndFlush(self.wrapOutboundOut(byteBuffer), promise: nil)
    }
    
    public func channelRead(ctx: ChannelHandlerContext, data: NIOAny) {
        var byteBuffer = self.unwrapInboundIn(data)
        readBuffer?.write(buffer: &byteBuffer)
    }
    
    public func channelReadComplete(ctx: ChannelHandlerContext) {
        guard let readBuffer = readBuffer else {
            ctx.close(promise: nil)
            return
        }
        let readMessage = readBuffer.getString(at: 0, length: readBuffer.readableBytes)!
        print("Client Received ", readMessage)
        assert(readMessage == "Netty rocks!")
    }
}
