package xione.fitmate.domain;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.CreationTimestamp;

import javax.persistence.*;
import javax.validation.constraints.NotBlank;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class BoardPost {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User userId;

    @NotBlank
    private String title;

    @Column(columnDefinition = "TEXT")
    private String content;

    @CreationTimestamp
    private LocalDateTime created_at;

    @NotBlank
    private String sports;

    @NotBlank
    private String location;

    @Column(nullable = false)
    private Integer numOfRecruits;


    @OneToMany(mappedBy = "post")
    private List<UserPost> participants = new ArrayList<>();

    @Column(nullable = false)
    private boolean isRecruiting;
}
