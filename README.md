# FinTarget-iOS
작업 순서 ✔️
이슈 생성
이슈 기반 브랜치 생성
작업 및 커밋
dev 브랜치로 PR 생성
리뷰 후 Squash and merge
브랜치 삭제
이슈 🗂️
제목은 [타입] 작업 내용 형식으로 작성 [Feat] 카카오 로그인 구현 [Fix] 정책 null 매칭 버그 수정 [Chore] application.yml gitignore 처리

작업 전 이슈 먼저 생성
담당자(Assignee) 지정
이슈는 PR 하나로 끝낼 수 있는 크기로 쪼개기
브랜치 전략 🌱
브랜치	설명
main	배포 가능한 안정 버전 (PR로만 머지)
dev	개발 통합 브랜치
feature/*	기능 개발
fix/*	버그 수정
chore/*	설정, 환경 등 기타 작업
브랜치 이름은 타입/이슈번호-작업내용 형식으로, 소문자와 하이픈(-) 사용 feature/1-kakao-login fix/2-policy-null-matching chore/3-gitignore-update

커밋 메시지 📝
type: 제목 (#이슈번호)

type	설명
feat	새로운 기능 추가
fix	버그 수정
docs	문서 수정
style	코드 포맷팅 (로직 변경 없음)
refactor	리팩토링
test	테스트 코드
chore	빌드, 설정 등 기타 작업
feat: 카카오 로그인 구현 (#1)	
fix: 정책 null 매칭 버그 수정 (#2)	
chore: application.yml gitignore 처리 (#3)	
제목은 50자 이내, 한국어 사용
제목 끝 마침표 생략
