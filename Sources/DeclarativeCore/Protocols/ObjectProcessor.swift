public protocol ObjectProcessor<Input, Output> {
	associatedtype Input
	associatedtype Output

	func process(_ input: Input) throws -> Output
}

// MARK: - Intrinsic

public extension ObjectProcessor {
	/// Apply the given `modifier` to the object processor.
	/// - Parameter modifier: The modifier to apply to the object processor.
	/// - Returns: The object processor with the given `modifier` applied.
	func modifier<Modifier>(
		_ modifier: Modifier
	) -> ModifiedObject<Self, Modifier> where
		Modifier: ObjectProcessor,
		Self.Output == Modifier.Input
	{
		ModifiedObject(upstream: self, downstream: modifier)
	}
}
