@frozen
public struct AnyObjectProcessor<Input, Output> {
	private let _process: (Input) throws -> Output

	init(_ process: @escaping (Input) throws -> Output) {
		_process = process
	}
}

// MARK: - ObjectProcessor

extension AnyObjectProcessor: ObjectProcessor {
	public func process(_ input: Input) throws -> Output {
		try _process(input)
	}
}

// MARK: - Typealias

public typealias PartialObjectProcessor<Input> = AnyObjectProcessor<Input, Any>

// MARK: - Convenience

public extension AnyObjectProcessor {
	init<Processor>(_ objectProcessor: Processor) where
		Processor: ObjectProcessor,
		Processor.Input == Input,
		Processor.Output == Output
	{
		let processFunction = if let existing = objectProcessor as? Self {
			existing._process
		} else {
			objectProcessor.process(_:)
		}
		self.init(processFunction)
	}

	init<Processor>(_ objectProcessor: Processor) where
		Processor: ObjectProcessor,
		Processor.Input == Input,
		Self.Output == Any
	{
		let processFunction = if let existing = objectProcessor as? Self {
			existing._process
		} else {
			objectProcessor.process(_:)
		}
		self.init(processFunction)
	}
}

public extension ObjectProcessor {
	func eraseToAnyObjectProcessor() -> AnyObjectProcessor<Input, Output> {
		AnyObjectProcessor(self)
	}

	func eraseToPartialObjectProcessor() -> PartialObjectProcessor<Input> {
		PartialObjectProcessor(self)
	}
}
