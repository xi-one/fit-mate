package xione.fitmate.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import xione.fitmate.domain.Sex;
import xione.fitmate.domain.User;
import xione.fitmate.repository.UserRepository;

import java.time.LocalDate;


@Service
@RequiredArgsConstructor
public class UserInfoService {

    private final UserRepository userRepository;

    @Transactional
    public void register(Long id, Sex sex, LocalDate birth, String region, String sports) {
        userRepository.updateSexAndBirthById(id, sex, birth, region, sports);

    }


}
