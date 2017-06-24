# Swift Lint

[![swift-ast 0.3.5](https://img.shields.io/badge/swift‐ast-0.3.5-C70025.svg)](https://github.com/yanagiba/swift-ast)
[![swift-lint master](https://img.shields.io/badge/swift‐lint-master-C70025.svg)](https://github.com/yanagiba/swift-lint)
[![swift-format pending](https://img.shields.io/badge/swift‐format-pending-C70025.svg)](https://github.com/yanagiba/swift-format)

[![Travis CI Status](https://api.travis-ci.org/yanagiba/swift-lint.svg?branch=master)](https://travis-ci.org/yanagiba/swift-lint)
[![codecov](https://codecov.io/gh/yanagiba/swift-lint/branch/master/graph/badge.svg)](https://codecov.io/gh/yanagiba/swift-lint)
![Swift 4.0-beta](https://img.shields.io/badge/swift-4.0‐beta-brightgreen.svg)
![Swift Package Manager](https://img.shields.io/badge/SPM-ready-orange.svg)
![Platforms](https://img.shields.io/badge/platform-%20Linux%20|%20macOS%20-red.svg)
![License](https://img.shields.io/github/license/yanagiba/swift-lint.svg)

The Swift Lint is a static code analysis tool for improving quality and reducing
defects by inspecting [Swift](https://swift.org/about/) code and looking for
potential problems like possible bugs, unused code, complicated code, redundant
code, code smells, bad practices, and so on.

Swift Lint relies on the [abstract syntax tree](https://github.com/yanagiba/swift-ast)
of the source code for better accuracy and efficiency.

* * *

- [Requirements](#requirements)
- [Installation](#installation)
  - [Standalone Tool](#standalone-tool)
  - [Embed Into Your Project](#embed-into-your-project)
- [Usage and Documentation](#usage--documentation)
  - [Command Line](#command-line)
  - [Documentation](#documentation)
- [Development](#development)
- [Contact](#contact)
- [License](#license)

* * *

## A Work In Progress

Both the [Swift Abstract Syntax Tree](https://github.com/yanagiba/swift-ast)
and the Swift Lint are in active development. Though many features are implemented, some with limitations.

Please also check out the [status](https://github.com/yanagiba/swift-ast#a-work-in-progress) from [swift-ast](https://github.com/yanagiba/swift-ast).

## Requirements

- [Swift 4.0-DEVELOPMENT-SNAPSHOT-2017-06-06-a](https://swift.org/download/)

## Installation

### Standalone Tool

To use it as a standalone tool, clone this repository to your local machine by

```bash
git clone https://github.com/yanagiba/swift-lint
```

Go to the repository folder, run the following command:

```bash
swift build -c release
```

This will generate a `swift-lint` executable inside `.build/release` folder.

#### Adding to `swift` Path (Recommended, but Optional)

It is possible to copy the `swift-lint` to the `bin` folder of
your local Swift installation.

For example, if `which swift` outputs

```
/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin
```

Then you can copy `swift-lint` to it by

```
cp .build/release/swift-lint /Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/swift-lint
```

Once you have done this, you can invoke `swift-lint` by
calling `swift lint` in your terminal directly.

### Embed Into Your Project

Add the swift-lint dependency to your SPM dependencies in Package.swift:

```swift
// swift-tools-version:4.0

import PackageDescription

let package = Package(
  name: "MyPackage",
  dependencies: [
    .package(url: "https://github.com/yanagiba/swift-lint.git", from: "0.1.2")
  ],
  targets: [
    .target(name: "MyTarget", dependencies: ["SwiftMetric", "SwiftLint"]),
  ],
  swiftLanguageVersions: [4]
)
```

An example project will be added in the future.

## Usage & Documentation

### Command Line

Simply append the path(s) of the file(s) to `swift-lint`:

```bash
swift-lint path/to/Awesome.swift
swift-lint path1/to1/foo.swift path2/to2/bar.swift ... path3/to3/main.swift
```

#### CLI Options

Run `swift-lint --help` to get the updated command line options.

### Documentation

Go to [Documentation](Documentation/README.md) for additional documentation.

## Development

### Build & Run

Building the entire project can be done by simply calling:

```bash
make
```

This is equivalent to

```bash
swift build
```

The dev version of the tool will be generated to `.build/debug/swift-lint`.

### Running Tests

Compile and run the entire tests by:

```bash
make test
```

## Contact

Ryuichi Saito

- http://github.com/ryuichis
- ryuichi@ryuichisaito.com

## License

Swift Lint is available under the Apache License 2.0.
See the [LICENSE](LICENSE) file for more info.
