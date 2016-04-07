# What is a process?

Simply a small structured segment of code that exists for one reason and one reason only. It is executed within its Heap Space and Event Loop so as not to block any other process that may wish to execute at the same point in time.

###  Stateless & Stateful

A process can be stateless, in that it accepts one set of inputs at the beginning and returns another when it competes. Providing the same inputs, results in the same outputs. Depending upon implementation the outputs could have been memorised or recalculated.

Stateful processes may be affected by their inputs. A sequence of inputs can change a process to a point, that providing a previous input may result in a different output or not output at all. Depending upon its implementation a stateful process may behaviour in any matter. The only guarantee offered is that the state is durable and reversible. 

Durable meaning that should the process lose resources, memory, processor, etc. When those resources become available again, the state is identical to itself at the time it lost the resources.

Reversible in that the process finds itself in can be reproduced. Hence starting at given point state can be reconstructed forward to an arbitrary point in time before the present.

###  Enduring & Ephemeral

Compared to the lifespan of the consumers of the Stateless and Stateful processes their life spans can be enduring or ephemeral. Largely self-determined by the process and opaque to the consumer.

##  The Registry

Facilitate the above behaviour of processes the a manner whereby the consumer simply references the process they require, passing it desired input. The process then carries out its purpose and returns any results to a specified location specified by the consumer.

###  Usage

Hence, from usage life perspective the consumer needs to lookup or discover the service they need, send it a request and specific where to deliver the response. The registry takes care of the rest of the life underlying lifecycle and mechanics to make this all possible.

Including:
- Providing a searchable directory of all available services.
- Provisioning the required service, that could require starting an isolate with a required code.
- Undertaking some initial handshake protocol to exchange communication ports.
- Carriage of the request from the consumer process and returning the processes reply.
- Continual monitoring of the processes and so they are available as when they are required.

### Process Building

The Registry also provides some functions and mixins that can be used to connect the process to the underlying communication channels the registry manages.

The assumption unpinning the Process Registry is that the developer wants access to non-block execution spaces for their applications. No matter where that application is deployed and does not want to rewrite and manage the plumbing and wiring to make this possible.

###  Context Process Usage 

Using a process within your application entails registering that process with the Registry. Registration is a low overhead once off async operation that can be a single or a large batch of processes. We have opted for programmatic execution of this so you at runtime we can pick which processes depending on any number of factors. Once done the registry is available within same Isolate scope.

To access a process, you need to obtain a reference to it. The reference is in the form of a closure returned from the registry. 

Calling the function with your input and reply address, causes it to be the process. The reply address is the SendPort portion of a ReceivePort that you have created and are monitoring. The process dispatched a response to you reply address, immediately upon process completion. Having the flexibility of the an ad-hoc reply address does means the registry does not close the port when it is no longer required. The responsibility remains with the caller of the creator of ReceivePort.

Should the called process return a single reply for your request. You can select not to supply a return address; you are then given a Future; that completes when the process does so.

###  Context Process Building

The work required is here is directly proportional to the work the process needs to carry out. Request received for the process are delivered to only one point, any required routing is the responsibility of the process itself.

The registry does deliver the message in a deserialized form of a Map with Enumerated keys. The registry does carry out serialization on the on Strings, Nums, Int, Dates, List and Enums. There is no validation of the request, beyond that of the standard message definition format.

Sending replies, a decision has to be made to as to where the reply should go. If there is reply address then simply use it. Otherwise, use the default reply address/ SendPort that was passed into your process when it started.