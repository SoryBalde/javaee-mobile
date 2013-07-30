package org.glassfish.javaee.mobile.server.chat;

import java.io.IOException;
import java.util.Collections;
import java.util.HashSet;
import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.websocket.EncodeException;
import javax.websocket.OnClose;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;

@ServerEndpoint(value = "/chat",
        encoders = {ChatMessage.class}, decoders = {ChatMessage.class})
public class ChatServer {

    private Set<Session> peers;

    public ChatServer() {
        peers = Collections.synchronizedSet(new HashSet<Session>());
    }

    @OnOpen
    public void onOpen(Session peer) {
        peers.add(peer);
    }

    @OnClose
    public void onClose(Session peer) {
        peers.remove(peer);
    }

    @OnMessage
    public void message(ChatMessage message, Session client) {
        for (Session peer : peers) {
            if (!peer.equals(client)) {
                try {
                    peer.getBasicRemote().sendObject(message);
                } catch (IOException | EncodeException ex) {
                    Logger.getLogger(ChatServer.class.getName()).log(
                            Level.SEVERE, "Error sending message", ex);
                }
            }
        }
    }
}