package xione.fitmate.payload.request;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
public class WithdrawRequest {
    private Long userId;
    private String address;
}
