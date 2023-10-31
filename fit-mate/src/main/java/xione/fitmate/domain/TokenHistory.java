package xione.fitmate.domain;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.CreationTimestamp;

import javax.persistence.*;
import javax.validation.constraints.NotBlank;
import java.time.LocalDateTime;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class TokenHistory {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private Long amount;

    @NotBlank
    private String content;

    @CreationTimestamp
    private LocalDateTime created_at;

    @ManyToOne
    @Column(nullable = false)
    private User user;

    public TokenHistory(Long amount, String content, User user) {
        this.amount = amount;
        this.content = content;
        this.user = user;
    }
}
