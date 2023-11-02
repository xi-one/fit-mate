package xione.fitmate.payload.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
public class withdrawResponse {
    private String status;
    private String txHash;
}
