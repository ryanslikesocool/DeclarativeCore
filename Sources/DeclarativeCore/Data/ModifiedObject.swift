import Combine

public struct ModifiedObject<Upstream, Downstream> {
	public let upstream: Upstream
	public let downstream: Downstream

	public init(upstream: Upstream, downstream: Downstream) {
		self.upstream = upstream
		self.downstream = downstream
	}
}

// MARK: - ObjectProcessor

extension ModifiedObject: ObjectProcessor where
	Upstream: ObjectProcessor,
	Downstream: ObjectProcessor,
	Upstream.Output == Downstream.Input
{
	public typealias Input = Upstream.Input
	public typealias Output = Downstream.Output

	public func process(_ input: Input) throws -> Output {
		let intermediate = try upstream.process(input)
		return try downstream.process(intermediate)
	}
}