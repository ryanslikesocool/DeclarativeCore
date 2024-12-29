public extension ObjectProcessorModifiers {
	/// ## See Also
	/// - ``ObjectProcessor/map(_:)-4f6to``
	/// - ``ObjectProcessor/map(_:)-5ly7l``
	struct Map<Input, Output>: ObjectProcessor {
		private let transform: (Input) throws -> Output

		public init(_ transform: @escaping (Input) throws -> Output) {
			self.transform = transform
		}

		public func process(_ input: Input) throws -> Output {
			try transform(input)
		}
	}
}

// MARK: - Convenience

public extension ObjectProcessor {
	/// Append a `map` operation to the object processor.
	func map<Output>(
		_ transform: @escaping (Self.Output) throws -> Output
	) -> ModifiedObject<Self, ObjectProcessorModifiers.Map<Self.Output, Output>> {
		let modifier = ObjectProcessorModifiers.Map<Self.Output, Output>(transform)
		return self.modifier(modifier)
	}

	/// Append a `map` operation to the object processor.
	func map<OutputElement>(
		_ transform: @escaping (Self.Output.Element) throws -> OutputElement
	) -> ModifiedObject<Self, ObjectProcessorModifiers.Map<Self.Output, [OutputElement]>> where
		Self.Output: Sequence
	{
		map { (input: Self.Output) throws -> [OutputElement] in
			try input.map(transform)
		}
	}
}
