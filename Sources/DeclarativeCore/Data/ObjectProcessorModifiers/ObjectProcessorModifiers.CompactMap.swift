public extension ObjectProcessorModifiers {
	/// ## See Also
	/// - ``ObjectProcessor/compactMap(_:)``
	/// - ``ObjectProcessor/compactMap()-14s5s``
	/// - ``ObjectProcessor/compactMap()-15mto``
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

public extension ObjectProcessor {
	/// Append a `compactMap` operation to the object processor.
	func compactMap<OutputElement>(
		_ transform: @escaping (Self.Output.Element) throws -> OutputElement?
	) -> ModifiedObject<Self, ObjectProcessorModifiers.CompactMap<Self.Output, OutputElement>> where
		Self.Output: Sequence
	{
		let modifier = ObjectProcessorModifiers.CompactMap<Self.Output, OutputElement>(transform)
		return self.modifier(modifier)
	}

	/// Append a `compactMap` operation to the object processor.
	func compactMap<Element>() -> ModifiedObject<Self, ObjectProcessorModifiers.CompactMap<Self.Output, Self.Output.Element>> where
		Self.Output: Sequence,
		Self.Output.Element == Element?
	{
		compactMap { (element: Element?) -> Element? in
			element
		}
	}

	/// Append a `compactMap` operation to the object processor, returning only successes.
	func compactMap<Success, Failure>() -> ModifiedObject<Self, ObjectProcessorModifiers.CompactMap<Self.Output, Success>> where
		Self.Output: Sequence,
		Self.Output.Element == Result<Success, Failure>,
		Failure: Error
	{
		compactMap { (element: Result<Success, Failure>) -> Success? in
			guard case let .success(success) = element else {
				return nil
			}
			return success
		}
	}
}
