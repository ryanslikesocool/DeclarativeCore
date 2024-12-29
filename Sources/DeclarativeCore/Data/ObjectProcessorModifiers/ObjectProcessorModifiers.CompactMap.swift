public extension ObjectProcessorModifiers {
	/// ## See Also
	/// - ``ObjectProcessor/compactMap(_:)``
	/// - ``ObjectProcessor/compactMap()-4idb1``
	/// - ``ObjectProcessor/compactMap()-4a9zm``
	struct CompactMap<Input, OutputElement>: ObjectProcessor where
		Input: Sequence
	{
		private let transform: (Input.Element) throws -> OutputElement?

		public init(_ transform: @escaping (Input.Element) throws -> OutputElement?) {
			self.transform = transform
		}

		public func process(_ input: Input) throws -> [OutputElement] {
			try input.compactMap(transform)
		}
	}
}

// MARK: - Convenience

public extension ObjectProcessorModifiers.CompactMap {
	init() where
		Input.Element == OutputElement?
	{
		self.init { (element: OutputElement?) -> OutputElement? in
			element
		}
	}

	init<Failure>() where
		Input: Sequence,
		Input.Element == Result<OutputElement, Failure>,
		Failure: Error
	{
		self.init { (element: Result<OutputElement, Failure>) -> OutputElement? in
			guard case let .success(success) = element else {
				return nil
			}
			return success
		}
	}
}

public extension ObjectProcessor where
	Output: Sequence
{
	/// Append a `compactMap` operation to the object processor.
	func compactMap<OutputElement>(
		_ transform: @escaping (Self.Output.Element) throws -> OutputElement?
	) -> ModifiedObject<Self, ObjectProcessorModifiers.CompactMap<Self.Output, OutputElement>> {
		let modifier = ObjectProcessorModifiers.CompactMap<Self.Output, OutputElement>(transform)
		return self.modifier(modifier)
	}

	/// Append a `compactMap` operation to the object processor.
	func compactMap<OutputElement>() -> ModifiedObject<Self, ObjectProcessorModifiers.CompactMap<Self.Output, OutputElement>> where
		Self.Output.Element == OutputElement?
	{
		let modifier = ObjectProcessorModifiers.CompactMap<Self.Output, OutputElement>()
		return self.modifier(modifier)
	}

	/// Append a `compactMap` operation to the object processor, returning only successes.
	func compactMap<Success, Failure>() -> ModifiedObject<Self, ObjectProcessorModifiers.CompactMap<Self.Output, Success>> where
		Self.Output.Element == Result<Success, Failure>,
		Failure: Error
	{
		let modifier = ObjectProcessorModifiers.CompactMap<Self.Output, Success>()
		return self.modifier(modifier)
	}
}
