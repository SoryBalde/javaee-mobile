package org.glassfish.javaee.mobile.server.chat;

import java.io.StringReader;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.json.Json;
import javax.json.JsonObject;
import javax.json.JsonReader;
import javax.websocket.Decoder;
import javax.websocket.Encoder;
import javax.websocket.EndpointConfig;

public class ChatMessage
        implements Decoder.Text<ChatMessage>, Encoder.Text<ChatMessage> {

    private String user;
    private String message;

    @Override
    public ChatMessage decode(String value) {
        try (JsonReader jsonReader = Json.createReader(
                new StringReader(value))) {
            JsonObject jsonObject = jsonReader.readObject();
            user = jsonObject.getString("user");
            message = jsonObject.getString("message");
        }

        return this;
    }

    @Override
    public boolean willDecode(String string) {
        return true;
    }

    @Override
    public String encode(ChatMessage chatMessage) {
        JsonObject jsonObject = Json.createObjectBuilder()
                .add("user", user)
                .add("message", message)
                .add("timestamp",
                new SimpleDateFormat("MM/dd/yyyy h:mm:ss a z")
                .format(new Date()))
                .build();

        return jsonObject.toString();
    }

    @Override
    public void init(EndpointConfig config) {
        // Nothing to do.
    }

    @Override
    public void destroy() {
        // Nothing to do.
    }
}