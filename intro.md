# About this Guide

Welcome to the developer's guide for Wallaroo.

You can open issues and submit pull requests against [our GitHub repo](https://github.com/wallaroolabs/wallaroo).

This document is has been written to take an application developer from zero knowledge about Wallaroo to being able to develop streaming Wallaroo applications in a local development environment using Go or Python. (For other languages such as C++, and for long-running data jobs such as large-scale analysis or model training, please contact us. Support and documentation are coming soon.)

Please contact us at [hello@wallaroolabs.com](mailto:hello@wallaroolabs.com) about how we can help you with your particular data processing applications.

## Intended Audience

We designed this document for programmers that want to jump right in and get started using Wallaroo.  Starting with installing all of the necessary components required for Wallaroo and launching an example application in a local development environment.

Although not required, you will get the most out of this tutorial if you have previous experience with Go and/or Python.  Additionally, experience with stream processing and distributed computing systems and concepts would be helpful.

## Supported development environments

It is currently possible to develop Wallaroo applications on MacOS and Linux. This guide has installation instructions for MacOS, and Ubuntu Linux. It's assumed if you are using a different Linux distribution that you are able to translate the Ubuntu instructions to your distribution of choice.

We also support development using a Docker container, installation instructions are included for MacOS and Ubuntu Linux.

## What to Expect

This document is organized into a number of sections. We recommend that you start in a linear fashion through this book. To that end, please consider reading in order:

- "What is Wallaroo"
- "Core Concepts"
- "Developing with Wallaroo"

Once you have finished the "Developing with Wallaroo" section, you can then jump to documentation for the language you will be developing with.

### Core Concepts

Covers the concepts you'll need to understand in order to build a Wallaroo application.

### Wallaroo with Python

How to develop Wallaroo applications using Python.

The ["Setting Up Your Environment for Wallaroo"](book/getting-started/setup.md) describes setting up your development environment and then compiling and running a Wallaroo application. The tools you will install then are useful when developing a Wallaroo application.

The Wallaroo Python API section takes you through a number of examples applications to teach you the Wallaroo Go API.

### Wallaroo with Go

How to develop Wallaroo applications using Go.

The ["Setting Up Your Environment for Wallaroo"](book/go/getting-started/setup.md) describes setting up your development environment and then compiling and running a Wallaroo application. The tools you will install then are useful when developing a Wallaroo application.

The Wallaroo Go API section takes you through a number of examples applications to teach you the Wallaroo Go API.

### Code Examples

The [Wallaroo Examples](https://github.com/WallarooLabs/wallaroo/tree/{{ book.wallaroo_version }}/examples) section has examples for each of the languages currently supported by Wallaroo.

### Appendix

Additional Wallaroo support documentation including detailed information about command-line options.

### Legal

Terms and conditions for Wallaroo's use.
