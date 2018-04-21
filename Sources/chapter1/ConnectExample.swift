import NIO

/// Listing 1.3 Asynchronous connect
/// Listing 1.4 Callback in action

public class ConnectExample {
    private let group = MultiThreadedEventLoopGroup(numThreads: 1)
    private let allocator = ByteBufferAllocator()
    
    /// Listing 1.3 Asynchronous connect
    /// Listing 1.4 Callback in action
    
    public func connect(ipAddress: String, port: UInt16, message: String) -> EventLoopFuture<Channel> {
        let clientBootstrap = ClientBootstrap(group: group)
        let address = try! SocketAddress(ipAddress: ipAddress, port: port)
        let channelFuture = clientBootstrap.connect(to: address)
        let promise: EventLoopPromise<Channel> = group.next().newPromise()
        channelFuture.whenSuccess { channel in
            var buffer = self.allocator.buffer(capacity: message.utf8.count)
            buffer.write(string: message)
            channel.writeAndFlush(buffer).whenComplete {
                promise.succeed(result: channel)
            }
        }
        channelFuture.whenFailure { error in
            promise.fail(error: error)
        }
        return promise.futureResult
    }
    
    deinit {
        try! group.syncShutdownGracefully()
    }
}
