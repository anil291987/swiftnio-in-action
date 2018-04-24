import NIO

// Listing 4.4 Asynchronous networking with Netty

public class SwiftNIOServer {
    private class CustomChannelInboundHandler: ChannelInboundHandler {
        public typealias InboundIn = ByteBuffer
        public typealias OutboundOut = ByteBuffer
        
        private var byteBuffer: ByteBuffer
        
        public init(_ byteBuffer: ByteBuffer) {
            self.byteBuffer = byteBuffer
        }
        
        func channelActive(ctx: ChannelHandlerContext) {
            ctx.writeAndFlush(self.wrapOutboundOut(byteBuffer), promise: nil)
        }
    }
    
    private static let group = MultiThreadedEventLoopGroup(numThreads: System.coreCount)
    
    public static func server(_ port: UInt16) throws -> Channel {
        let allocator = ByteBufferAllocator()
        let message = "Hi!\r\n"
        var byteBuffer = allocator.buffer(capacity: message.utf8.count)
        byteBuffer.write(string: message)
        let serverChannel = try ServerBootstrap(group: group)
            .serverChannelOption(ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR), value: 1)
            .childChannelInitializer { channel -> EventLoopFuture<Void> in
                return channel.pipeline.add(handler: CustomChannelInboundHandler(byteBuffer))
        }.bind(host: "127.0.0.1", port: Int(port)).wait()
        // serverChannel.closeFuture.wait()
        return serverChannel
    }
}
