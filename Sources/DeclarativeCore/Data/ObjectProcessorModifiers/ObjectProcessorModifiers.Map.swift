public extension ObjectProcessorModifiers {
	/// The map modifier.
	///
	/// ## See Also
	/// - ``ObjectProcessor/map(_:)-4f6to``
	/// - ``ObjectProcessor/map(_:)-5ly7l``
	struct Map<Input, Output>: ObjectProcessor {
		private let transform: (Input) throws -> Output

		/// Create a map modifier.
		public init(
			_ transform: @escaping (Input) throws -> Output
		) {
			self.transform = transform
		}

		public func process(_ input: Input) throws -> Output {
			try transform(input)
		}
	}
}

// MARK: - Convenience

public extension ObjectProcessorModifiers.Map {
	/// Create a map modifier.
	init<OutputElement>(
		_ transform: @escaping (Input.Element) throws -> OutputElement
	) where
		Input: Sequence,
		Output == [OutputElement]
	{
		self.init { (input: Input) throws -> [OutputElement] in
			try input.map(transform)
		}
	}
}

public extension ObjectProcessor {
	/// Append a `map` operation to the object processor.
	///
	/// ## See Also
	/// - ``ObjectProcessorModifiers/Map``
	func map<Output>(
		_ transform: @escaping (Self.Output) throws -> Output
	) -> ModifiedObject<Self, ObjectProcessorModifiers.Map<Self.Output, Output>> {
		let modifier = ObjectProcessorModifiers.Map<Self.Output, Output>(transform)
		return self.modifier(modifier)
	}

	/// Append a `map` operation to the object processor.
	///
	/// ## See Also
	/// - ``ObjectProcessorModifiers/Map``
	func map<OutputElement>(
		_ transform: @escaping (Self.Output.Element) throws -> OutputElement
	) -> ModifiedObject<Self, ObjectProcessorModifiers.Map<Self.Output, [OutputElement]>> where
		Self.Output: Sequence
	{
		let modifier = ObjectProcessorModifiers.Map<Self.Output, [OutputElement]>(transform)
		return self.modifier(modifier)
	}
}
