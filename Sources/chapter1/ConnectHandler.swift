import NIO

// Listing 1.2 ChannelHandler triggered by a callback

public class ConnectHandler: ChannelInboundHandler {
    public typealias InboundIn = ByteBuffer
    
    public func channelActive(ctx: ChannelHandlerContext) {
        print("Client ", ctx.remoteAddress!, " connected")
    }
}
