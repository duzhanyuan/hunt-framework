/*
 * Hunt - A high-level D Programming Language Web framework that encourages rapid development and clean, pragmatic design.
 *
 * Copyright (C) 2015-2019, HuntLabs
 *
 * Website: https://www.huntlabs.net/
 *
 * Licensed under the Apache-2.0 License.
 *
 */

module hunt.framework.websocket.config.annotation.WebSocketTransportRegistration;


import hunt.collection;

import hunt.framework.websocket.server.WebSocketHandlerDecorator;

/**
 * Configure the processing of messages received from and sent to WebSocket clients.
 *
 * @author Rossen Stoyanchev
 * @since 4.0.3
 */
class WebSocketTransportRegistration {
	
	private int messageSizeLimit;
	private int sendTimeLimit;
	private int sendBufferSizeLimit;
	private int timeToFirstMessage;
	private WebSocketHandlerDecoratorFactory[] decoratorFactories;

	this() {
		// decoratorFactories = new ArrayList!WebSocketHandlerDecoratorFactory(2);
	}


	/**
	 * Configure the maximum size for an incoming sub-protocol message.
	 * For example a STOMP message may be received as multiple WebSocket messages
	 * or multiple HTTP POST requests when SockJS fallback options are in use.
	 * <p>In theory a WebSocket message can be almost unlimited in size.
	 * In practice WebSocket servers impose limits on incoming message size.
	 * STOMP clients for example tend to split large messages around 16K
	 * boundaries. Therefore a server must be able to buffer partial content
	 * and decode when enough data is received. Use this property to configure
	 * the max size of the buffer to use.
	 * <p>The default value is 64K (i.e. 64 * 1024).
	 * <p><strong>NOTE</strong> that the current version 1.2 of the STOMP spec
	 * does not specifically discuss how to send STOMP messages over WebSocket.
	 * Version 2 of the spec will but in the mean time existing client libraries
	 * have already established a practice that servers must handle.
	 */
	WebSocketTransportRegistration setMessageSizeLimit(int messageSizeLimit) {
		this.messageSizeLimit = messageSizeLimit;
		return this;
	}

	/**
	 * Protected accessor for internal use.
	 */
	int getMessageSizeLimit() {
		return this.messageSizeLimit;
	}

	/**
	 * Configure a time limit (in milliseconds) for the maximum amount of a time
	 * allowed when sending messages to a WebSocket session or writing to an
	 * HTTP response when SockJS fallback option are in use.
	 * <p>In general WebSocket servers expect that messages to a single WebSocket
	 * session are sent from a single thread at a time. This is automatically
	 * guaranteed when using {@code @EnableWebSocketMessageBroker} configuration.
	 * If message sending is slow, or at least slower than rate of messages sending,
	 * subsequent messages are buffered until either the {@code sendTimeLimit}
	 * or the {@code sendBufferSizeLimit} are reached at which point the session
	 * state is cleared and an attempt is made to close the session.
	 * <p><strong>NOTE</strong> that the session time limit is checked only
	 * on attempts to send additional messages. So if only a single message is
	 * sent and it hangs, the session will not time out until another message is
	 * sent or the underlying physical socket times out. So this is not a
	 * replacement for WebSocket server or HTTP connection timeout but is rather
	 * intended to control the extent of buffering of unsent messages.
	 * <p><strong>NOTE</strong> that closing the session may not succeed in
	 * actually closing the physical socket and may also hang. This is true
	 * especially when using blocking IO such as the BIO connector in Tomcat
	 * that is used by default on Tomcat 7. Therefore it is recommended to ensure
	 * the server is using non-blocking IO such as Tomcat's NIO connector that
	 * is used by default on Tomcat 8. If you must use blocking IO consider
	 * customizing OS-level TCP settings, for example
	 * {@code /proc/sys/net/ipv4/tcp_retries2} on Linux.
	 * <p>The default value is 10 seconds (i.e. 10 * 10000).
	 * @param timeLimit the timeout value in milliseconds; the value must be
	 * greater than 0, otherwise it is ignored.
	 */
	WebSocketTransportRegistration setSendTimeLimit(int timeLimit) {
		this.sendTimeLimit = timeLimit;
		return this;
	}

	/**
	 * Protected accessor for internal use.
	 */
	
	int getSendTimeLimit() {
		return this.sendTimeLimit;
	}

	/**
	 * Configure the maximum amount of data to buffer when sending messages
	 * to a WebSocket session, or an HTTP response when SockJS fallback
	 * option are in use.
	 * <p>In general WebSocket servers expect that messages to a single WebSocket
	 * session are sent from a single thread at a time. This is automatically
	 * guaranteed when using {@code @EnableWebSocketMessageBroker} configuration.
	 * If message sending is slow, or at least slower than rate of messages sending,
	 * subsequent messages are buffered until either the {@code sendTimeLimit}
	 * or the {@code sendBufferSizeLimit} are reached at which point the session
	 * state is cleared and an attempt is made to close the session.
	 * <p><strong>NOTE</strong> that closing the session may not succeed in
	 * actually closing the physical socket and may also hang. This is true
	 * especially when using blocking IO such as the BIO connector in Tomcat
	 * configured by default on Tomcat 7. Therefore it is recommended to ensure
	 * the server is using non-blocking IO such as Tomcat's NIO connector used
	 * by default on Tomcat 8. If you must use blocking IO consider customizing
	 * OS-level TCP settings, for example {@code /proc/sys/net/ipv4/tcp_retries2}
	 * on Linux.
	 * <p>The default value is 512K (i.e. 512 * 1024).
	 * @param sendBufferSizeLimit the maximum number of bytes to buffer when
	 * sending messages; if the value is less than or equal to 0 then buffering
	 * is effectively disabled.
	 */
	WebSocketTransportRegistration setSendBufferSizeLimit(int sendBufferSizeLimit) {
		this.sendBufferSizeLimit = sendBufferSizeLimit;
		return this;
	}

	/**
	 * Protected accessor for internal use.
	 */
	
	int getSendBufferSizeLimit() {
		return this.sendBufferSizeLimit;
	}

	/**
	 * Set the maximum time allowed in milliseconds after the WebSocket connection
	 * is established and before the first sub-protocol message is received.
	 * <p>This handler is for WebSocket connections that use a sub-protocol.
	 * Therefore, we expect the client to send at least one sub-protocol message
	 * in the beginning, or else we assume the connection isn't doing well, e.g.
	 * proxy issue, slow network, and can be closed.
	 * <p>By default this is set to {@code 60,000} (1 minute).
	 * @param timeToFirstMessage the maximum time allowed in milliseconds
	 * @since 5.1
	 */
	WebSocketTransportRegistration setTimeToFirstMessage(int timeToFirstMessage) {
		this.timeToFirstMessage = timeToFirstMessage;
		return this;
	}

	/**
	 * Protected accessor for internal use.
	 */
	int getTimeToFirstMessage() {
		return this.timeToFirstMessage;
	}

	/**
	 * Configure one or more factories to decorate the handler used to process
	 * WebSocket messages. This may be useful in some advanced use cases, for
	 * example to allow Spring Security to forcibly close the WebSocket session
	 * when the corresponding HTTP session expires.
	 * @since 4.1.2
	 */
	WebSocketTransportRegistration setDecoratorFactories(WebSocketHandlerDecoratorFactory[] factories...) {
		this.decoratorFactories ~= factories;
		return this;
	}

	/**
	 * Add a factory that to decorate the handler used to process WebSocket
	 * messages. This may be useful for some advanced use cases, for example
	 * to allow Spring Security to forcibly close the WebSocket session when
	 * the corresponding HTTP session expires.
	 * @since 4.1.2
	 */
	WebSocketTransportRegistration addDecoratorFactory(WebSocketHandlerDecoratorFactory factory) {
		this.decoratorFactories ~= factory;
		return this;
	}

	WebSocketHandlerDecoratorFactory[] getDecoratorFactories() {
		return this.decoratorFactories;
	}

}
