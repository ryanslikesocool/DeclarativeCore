/// ## See Also
/// - ``ObjectProcessor/modifier(_:)``
public struct ModifiedObject<Upstream, Downstream> {
	/// The upstream object.
	public let upstream: Upstream

	/// The downstream object.
	public let downstream: Downstream
	
	/// Create a modified object.
	/// - Parameters:
	///   - upstream: The upstream object.
	///   - downstream: The downstream object.
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
