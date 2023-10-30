package xione.fitmate.payload.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import xione.fitmate.domain.AuthProvider;
import xione.fitmate.domain.Role;
import xione.fitmate.domain.Sex;

import javax.persistence.*;
import java.time.LocalDate;
import java.util.List;

@Getter
@Setter
@AllArgsConstructor
public class UserInfoResponse {
    private Long id;
    private String name;
    private Sex sex;
    private String email;
    private LocalDate birth;
    private List<String> sports;
    private String img;
    private Long cash;
    private String region;
}
