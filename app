<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>AI 상식 도전!</title>
  <style>
    :root {
      --primary: #4f46e5;
      --primary-hover: #4338ca;
      --bg-color: #f0f4ff;
      --card-bg: #ffffff;
      --text-main: #1f2937;
      --text-sub: #4b5563;
      --correct-bg: #d1fae5;
      --correct-border: #10b981;
      --correct-text: #065f46;
      --wrong-bg: #fee2e2;
      --wrong-border: #f87171;
      --wrong-text: #991b1b;
      --radius: 20px;
    }

    * {
      box-sizing: border-box;
      margin: 0;
      padding: 0;
      font-family: 'Pretendard', 'Malgun Gothic', '맑은 고딕', sans-serif;
    }

    body {
      background-color: var(--bg-color);
      color: var(--text-main);
      display: flex;
      justify-content: center;
      align-items: center;
      min-height: 100vh;
      padding: 16px;
    }

    .app-card {
      background-color: var(--card-bg);
      width: 100%;
      max-width: 500px;
      padding: 28px 20px;
      border-radius: var(--radius);
      box-shadow: 0 10px 25px rgba(79, 70, 229, 0.12);
      text-align: center;
      position: relative;
      overflow: hidden;
    }

    header h1 {
      font-size: 1.8rem;
      color: var(--primary);
      margin-bottom: 16px;
      font-weight: 800;
    }

    /* 진행 상황 */
    .progress-box {
      margin-bottom: 20px;
    }

    .progress-text {
      font-size: 1.2rem;
      font-weight: 700;
      color: var(--text-sub);
      margin-bottom: 8px;
    }

    .progress-bar-bg {
      background-color: #e5e7eb;
      height: 12px;
      border-radius: 10px;
      overflow: hidden;
    }

    .progress-bar-fill {
      background-color: var(--primary);
      height: 100%;
      width: 20%;
      transition: width 0.3s ease;
    }

    /* 문제 카드 */
    .question-title {
      font-size: 1.35rem;
      font-weight: 800;
      color: var(--text-main);
      line-height: 1.45;
      margin-bottom: 20px;
      word-break: keep-all;
      min-height: 3.8rem;
      display: flex;
      align-items: center;
      justify-content: center;
    }

    /* 보기 버튼 목록 */
    .options-list {
      display: flex;
      flex-direction: column;
      gap: 12px;
      margin-bottom: 20px;
    }

    .option-btn {
      background-color: #f9fafb;
      border: 2.5px solid #e5e7eb;
      border-radius: 16px;
      padding: 16px 18px;
      font-size: 1.15rem;
      font-weight: 700;
      color: var(--text-main);
      text-align: left;
      cursor: pointer;
      transition: all 0.15s ease;
      line-height: 1.3;
      word-break: keep-all;
    }

    .option-btn:hover:not(:disabled) {
      border-color: var(--primary);
      background-color: #eef2ff;
    }

    .option-btn:active:not(:disabled) {
      transform: scale(0.98);
    }

    .option-btn.selected-correct {
      background-color: var(--correct-bg);
      border-color: var(--correct-border);
      color: var(--correct-text);
    }

    .option-btn.selected-wrong {
      background-color: var(--wrong-bg);
      border-color: var(--wrong-border);
      color: var(--wrong-text);
    }

    .option-btn:disabled {
      cursor: default;
    }

    /* 피드백 박스 */
    .feedback-box {
      margin-top: 15px;
      padding: 16px;
      border-radius: 16px;
      font-size: 1.25rem;
      font-weight: 800;
      animation: popIn 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
    }

    .feedback-box.correct {
      background-color: var(--correct-bg);
      color: var(--correct-text);
      border: 2px solid var(--correct-border);
    }

    .feedback-box.wrong {
      background-color: var(--wrong-bg);
      color: var(--wrong-text);
      border: 2px solid var(--wrong-border);
    }

    /* 다음 버튼 */
    .next-btn, .restart-btn {
      width: 100%;
      background-color: var(--primary);
      color: white;
      border: none;
      padding: 18px;
      font-size: 1.3rem;
      font-weight: 800;
      border-radius: 16px;
      cursor: pointer;
      margin-top: 16px;
      box-shadow: 0 5px 0 #3730a3;
      transition: all 0.1s ease;
    }

    .next-btn:active, .restart-btn:active {
      box-shadow: 0 2px 0 #3730a3;
      transform: translateY(3px);
    }

    /* 결과 화면 */
    .result-screen {
      padding: 10px 0;
    }

    .result-emoji {
      font-size: 4.5rem;
      margin-bottom: 10px;
      display: block;
      animation: bounce 1s infinite alternate;
    }

    .result-badge {
      font-size: 2.2rem;
      font-weight: 900;
      color: var(--primary);
      margin-bottom: 12px;
    }

    .result-score {
      font-size: 1.3rem;
      font-weight: 700;
      color: var(--text-sub);
      margin-bottom: 24px;
    }

    .hidden {
      display: none !important;
    }

    /* 애니메이션 */
    @keyframes popIn {
      0% { transform: scale(0.85); opacity: 0; }
      100% { transform: scale(1); opacity: 1; }
    }

    @keyframes bounce {
      0% { transform: translateY(0); }
      100% { transform: translateY(-10px); }
    }

    /* 폭죽 이펙트 조각 */
    .sparkle {
      position: absolute;
      width: 10px;
      height: 10px;
      border-radius: 50%;
      pointer-events: none;
      animation: fly 0.8s ease-out forwards;
    }

    @keyframes fly {
      0% { transform: translate(0, 0) scale(1); opacity: 1; }
      100% { transform: translate(var(--tw-x), var(--tw-y)) scale(0); opacity: 0; }
    }
  </style>
</head>
<body>

  <div class="app-card">
    <header>
      <h1>🤖 AI 상식 도전!</h1>
    </header>

    <!-- 퀴즈 화면 -->
    <main id="quizScreen">
      <div class="progress-box">
        <div class="progress-text" id="progressText">현재 문제 1 / 5</div>
        <div class="progress-bar-bg">
          <div class="progress-bar-fill" id="progressBar"></div>
        </div>
      </div>

      <div class="question-title" id="questionTitle">
        문제를 불러오는 중입니다...
      </div>

      <div class="options-list" id="optionsContainer">
        <!-- 보기 버튼 생성 영역 -->
      </div>

      <div id="feedbackArea" class="hidden">
        <div id="feedbackBox" class="feedback-box"></div>
        <button class="next-btn" id="nextBtn" onclick="nextQuestion()">다음 문제로 ➡️</button>
      </div>
    </main>

    <!-- 결과 화면 -->
    <main id="resultScreen" class="result-screen hidden">
      <span class="result-emoji" id="resultEmoji">🏆</span>
      <div class="result-badge" id="resultBadge">🏆 AI 박사!</div>
      <div class="result-score" id="resultScore">5문제 중 5문제를 맞히셨어요!</div>
      <button class="restart-btn" onclick="restartQuiz()">🔄 다시 도전하기</button>
    </main>
  </div>

  <script>
    // 5개의 쉬운 AI 상식 문제 데이터
    const questions = [
      {
        question: "1. AI는 무슨 뜻일까요?",
        options: [
          "인공지능 (Artificial Intelligence)",
          "스마트폰 애플리케이션",
          "무선 와이파이 신호",
          "자동 결제 시스템"
        ],
        answer: 0
      },
      {
        question: "2. 사람처럼 대화하고 궁금한 것을 답해주는 대표적인 AI 서비스는?",
        options: [
          "알약 (백신 프로그램)",
          "챗GPT (ChatGPT)",
          "한글과컴퓨터",
          "전자계산기"
        ],
        answer: 1
      },
      {
        question: "3. 생성형 AI에게 질문이나 명령을 입력하는 글을 무엇이라고 부를까요?",
        options: [
          "프롬프트 (Prompt)",
          "비밀번호 (Password)",
          "아이디 (ID)",
          "이메일 주소"
        ],
        answer: 0
      },
      {
        question: "4. AI를 지혜롭게 사용하는 올바른 자세는 무엇일까요?",
        options: [
          "AI가 알려준 정보가 맞는지 한 번 더 확인한다.",
          "AI가 하는 말은 무조건 100% 신뢰한다.",
          "주민번호나 계좌번호를 AI에 모두 알려준다.",
          "AI에게 거짓말만 하도록 시킨다."
        ],
        answer: 0
      },
      {
        question: "5. 다음 중 생성형 AI가 직접 할 수 없는 일은 무엇일까요?",
        options: [
          "시나 멋진 편지글 작성하기",
          "예쁜 그림이나 사진 그리기",
          "따뜻한 집밥 직접 요리해서 가져오기",
          "외국어 문장 번역하기"
        ],
        answer: 2
      }
    ];

    let currentQuestionIndex = 0;
    let score = 0;

    const quizScreen = document.getElementById('quizScreen');
    const resultScreen = document.getElementById('resultScreen');
    const progressText = document.getElementById('progressText');
    const progressBar = document.getElementById('progressBar');
    const questionTitle = document.getElementById('questionTitle');
    const optionsContainer = document.getElementById('optionsContainer');
    const feedbackArea = document.getElementById('feedbackArea');
    const feedbackBox = document.getElementById('feedbackBox');

    // 첫 문제 표시
    loadQuestion();

    function loadQuestion() {
      const q = questions[currentQuestionIndex];
      
      // 진행 상황 업데이트
      progressText.textContent = `현재 문제 ${currentQuestionIndex + 1} / ${questions.length}`;
      progressBar.style.width = `${((currentQuestionIndex + 1) / questions.length) * 100}%`;

      // 문제 제목 표시
      questionTitle.textContent = q.question;

      // 보기 초기화
      optionsContainer.innerHTML = '';
      feedbackArea.classList.add('hidden');

      q.options.forEach((optText, idx) => {
        const btn = document.createElement('button');
        btn.className = 'option-btn';
        btn.innerHTML = `<strong>${idx + 1}.</strong> ${optText}`;
        btn.onclick = () => checkAnswer(idx);
        optionsContainer.appendChild(btn);
      });
    }

    function checkAnswer(selectedIndex) {
      const q = questions[currentQuestionIndex];
      const buttons = optionsContainer.children;

      // 모든 버튼 비활성화
      for (let btn of buttons) {
        btn.disabled = true;
      }

      const isCorrect = selectedIndex === q.answer;

      if (isCorrect) {
        score++;
        buttons[selectedIndex].classList.add('selected-correct');
        feedbackBox.className = 'feedback-box correct';
        feedbackBox.textContent = '⭕ 정답입니다!';
        triggerCelebration();
      } else {
        buttons[selectedIndex].classList.add('selected-wrong');
        buttons[q.answer].classList.add('selected-correct'); // 정답 보기 강조
        feedbackBox.className = 'feedback-box wrong';
        feedbackBox.textContent = `❌ 아쉬워요. 정답은 ${q.answer + 1}번입니다.`;
      }

      feedbackArea.classList.remove('hidden');
    }

    function nextQuestion() {
      currentQuestionIndex++;
      if (currentQuestionIndex < questions.length) {
        loadQuestion();
      } else {
        showResult();
      }
    }

    function showResult() {
      quizScreen.classList.add('hidden');
      resultScreen.classList.remove('hidden');

      const resultBadge = document.getElementById('resultBadge');
      const resultEmoji = document.getElementById('resultEmoji');
      const resultScore = document.getElementById('resultScore');

      resultScore.textContent = `총 ${questions.length}문제 중 ${score}문제를 맞히셨어요!`;

      // 점수별 결과 메시지 설정
      if (score === 5) {
        resultEmoji.textContent = '🏆';
        resultBadge.textContent = '🏆 AI 박사!';
      } else if (score === 4) {
        resultEmoji.textContent = '🎉';
        resultBadge.textContent = '🎉 AI 우등생!';
      } else if (score >= 2) {
        resultEmoji.textContent = '👍';
        resultBadge.textContent = '👍 AI 새싹!';
      } else {
        resultEmoji.textContent = '🌱';
        resultBadge.textContent = '🌱 이제 시작이에요!';
      }
    }

    function restartQuiz() {
      currentQuestionIndex = 0;
      score = 0;
      resultScreen.classList.add('hidden');
      quizScreen.classList.remove('hidden');
      loadQuestion();
    }

    // 간단한 정답 축하 애니메이션 (작은 빛가루 효과)
    function triggerCelebration() {
      const colors = ['#10b981', '#3b82f6', '#f59e0b', '#ec4899'];
      const card = document.querySelector('.app-card');
      
      for (let i = 0; i < 20; i++) {
        const sparkle = document.createElement('div');
        sparkle.className = 'sparkle';
        sparkle.style.backgroundColor = colors[Math.floor(Math.random() * colors.length)];
        
        const angle = Math.random() * Math.PI * 2;
        const dist = 60 + Math.random() * 80;
        const x = Math.cos(angle) * dist;
        const y = Math.sin(angle) * dist;

        sparkle.style.left = '50%';
        sparkle.style.top = '40%';
        sparkle.style.setProperty('--tw-x', `${x}px`);
        sparkle.style.setProperty('--tw-y', `${y}px`);

        card.appendChild(sparkle);
        setTimeout(() => sparkle.remove(), 800);
      }
    }
  </script>
</body>
</html>

