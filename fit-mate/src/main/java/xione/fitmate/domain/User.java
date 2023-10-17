package xione.fitmate.domain;

import lombok.*;

import javax.persistence.*;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Getter
@ToString
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
@Table(name = "user_table")
public class User extends BaseTimeEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true, nullable = false)
    private String oAuth2Id;

    @Column(nullable = false)
    private String name;

    @Enumerated(EnumType.STRING)
    @Column
    private Sex sex;

    @Column(nullable = false)
    private String email;

    @Column
    private LocalDate birth;

    @Column
    private String sports;

    @Column
    private String img;

    @Column
    private Long cash;

    @Column
    private String region;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Role role;

    @Enumerated(EnumType.STRING)
    private AuthProvider authProvider;

    private String refreshToken;



    public User update(String name, String img) {
        this.name = name;
        this.img = img;

        return this;
    }

    public String getRoleKey() {
        return this.role.getKey();
    }
}
