import NIO

// Listing 2.1 EchoServerHandler

public class EchoServerHandler: ChannelInboundHandler {
    public typealias InboundIn = ByteBuffer
    public typealias OutboundOut = ByteBuffer
    
    public func channelRead(ctx: ChannelHandlerContext, data: NIOAny) {
        let byteBuffer = self.unwrapInboundIn(data)
        print("Server received: ", byteBuffer.getString(at: 0, length: byteBuffer.readableBytes)!)
        ctx.write(self.wrapOutboundOut(byteBuffer), promise: nil)
    }
    
    public func channelReadComplete(ctx: ChannelHandlerContext) {
        ctx.flush()
        ctx.close(promise: nil)
    }
    
    public func errorCaught(ctx: ChannelHandlerContext, error: Error) {
        print(error)
        ctx.close(promise: nil)
    }
}
