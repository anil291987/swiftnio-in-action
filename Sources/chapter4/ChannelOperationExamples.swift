import NIO
import Dispatch

// Listing 4.5 Writing to a Channel
// Listing 4.6 Using a Channel from many threads

public class ChannelOperationExamples {
    
    private var CHANNEL_FROM_SOMEWHERE: Channel?
    
    public init(_ channel: Channel) {
        self.CHANNEL_FROM_SOMEWHERE = channel
    }
    
    // Listing 4.5 Writing to a Channel
    
    public func writingToChannel() {
        let channel = CHANNEL_FROM_SOMEWHERE
        
        let message = "some message"
        var byteBuffer = channel?.allocator.buffer(capacity: message.utf8.count)
        byteBuffer?.write(string: message)
        
        let writeFuture = channel?.writeAndFlush(byteBuffer)
        
        writeFuture?.whenSuccess({ _ in
            print("Write Success")
        })
        
        writeFuture?.whenFailure({ (error) in
            print(error)
        })
    }
    
    // Listing 4.6 Using a Channel from many threads
    
    public func writingToChannelFromManyThreads() {
        let channel = CHANNEL_FROM_SOMEWHERE
        
        let message = "some message"
        var byteBuffer = channel!.allocator.buffer(capacity: message.utf8.count)
        byteBuffer.write(string: message)
        
        let writer = {
            _ = channel?.write(byteBuffer)
        }
        
        let dispatchQueue = DispatchQueue(label: "concurrent", attributes: .concurrent)
        
        dispatchQueue.async(execute: writer)
        dispatchQueue.async(execute: writer)
    }
}
