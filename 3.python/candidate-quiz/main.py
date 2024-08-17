import logging
from flask import Flask, render_template_string, request, redirect, url_for, make_response

# Setup logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Define the Flask application
app = Flask(__name__)

# Define quiz data
quiz_data = [
    {
        "id": 1,
        "question": "What is the capital of France?",
        "choice_1": "Berlin",
        "choice_2": "Madrid",
        "choice_3": "Paris",
        "choice_4": "Rome",
        "correct_answer": 3
    },
    {
        "id": 2,
        "question": "What is the largest planet in our solar system?",
        "choice_1": "Earth",
        "choice_2": "Jupiter",
        "choice_3": "Mars",
        "choice_4": "Saturn",
        "correct_answer": 2
    },
    {
        "id": 3,
        "question": "What is the boiling point of water?",
        "choice_1": "90°C",
        "choice_2": "100°C",
        "choice_3": "110°C",
        "choice_4": "120°C",
        "correct_answer": 2
    },
    {
        "id": 4,
        "question": "Who wrote 'Romeo and Juliet'?",
        "choice_1": "Charles Dickens",
        "choice_2": "Mark Twain",
        "choice_3": "William Shakespeare",
        "choice_4": "Jane Austen",
        "correct_answer": 3
    },
    {
        "id": 5,
        "question": "What is the chemical symbol for gold?",
        "choice_1": "Au",
        "choice_2": "Ag",
        "choice_3": "Pb",
        "choice_4": "Fe",
        "correct_answer": 1
    },
    {
        "id": 6,
        "question": "What is the smallest prime number?",
        "choice_1": "0",
        "choice_2": "1",
        "choice_3": "2",
        "choice_4": "3",
        "correct_answer": 3
    },
    {
        "id": 7,
        "question": "Which ocean is the largest?",
        "choice_1": "Atlantic Ocean",
        "choice_2": "Indian Ocean",
        "choice_3": "Arctic Ocean",
        "choice_4": "Pacific Ocean",
        "correct_answer": 4
    },
    {
        "id": 8,
        "question": "Who painted the Mona Lisa?",
        "choice_1": "Vincent Van Gogh",
        "choice_2": "Leonardo da Vinci",
        "choice_3": "Pablo Picasso",
        "choice_4": "Claude Monet",
        "correct_answer": 2
    },
    {
        "id": 9,
        "question": "How many continents are there?",
        "choice_1": "5",
        "choice_2": "6",
        "choice_3": "7",
        "choice_4": "8",
        "correct_answer": 3
    },
    {
        "id": 10,
        "question": "What is the fastest land animal?",
        "choice_1": "Cheetah",
        "choice_2": "Lion",
        "choice_3": "Horse",
        "choice_4": "Elephant",
        "correct_answer": 1
    }
]

# Home route with welcome message
@app.route('/')
def home():
    return render_template_string("""
    <h1>Welcome to the Quiz!</h1>
    <p>Instructions: You will be presented with 10 questions. Each question has four choices. Select the correct answer and click 'Submit' to proceed.</p>
    <p>Each question must be answered within 10 seconds, or else it will automatically score zero. Good luck!</p>
    <form action="{{ url_for('start_quiz') }}" method="post">
        <button type="submit">Begin the Test</button>
    </form>
    """)

@app.route('/start_quiz', methods=['POST'])
def start_quiz():
    response = make_response(redirect(url_for('question', question_id=1)))
    response.set_cookie('score', '0')
    return response

# Route for each question
@app.route('/question/<int:question_id>', methods=['GET', 'POST'])
def question(question_id):
    if question_id < 1 or question_id > len(quiz_data):
        logger.info(f"Question ID {question_id} out of range.")
        return redirect(url_for('score'))
    
    question_data = quiz_data[question_id - 1]
    
    if request.method == 'POST':
        selected_answer = int(request.form.get('answer', 0))
        if 'score' not in request.cookies:
            score = 0
        else:
            score = int(request.cookies.get('score'))
        
        time_elapsed = int(request.form.get('time_elapsed', 0))
        
        if time_elapsed <= 10 and selected_answer == question_data['correct_answer']:
            score += 1
        
        response = redirect(url_for('question', question_id=question_id + 1))
        response.set_cookie('score', str(score))
        return response

    return render_template_string("""
    <h1>Question {{ question_data['id'] }}</h1>
    <p>{{ question_data['question'] }}</p>
    <form method="post" onsubmit="return setTimeElapsed()">
        <div>
            <input type="radio" id="choice_1" name="answer" value="1" required>
            <label for="choice_1">{{ question_data.choice_1 }}</label>
        </div>
        <div>
            <input type="radio" id="choice_2" name="answer" value="2">
            <label for="choice_2">{{ question_data.choice_2 }}</label>
        </div>
        <div>
            <input type="radio" id="choice_3" name="answer" value="3">
            <label for="choice_3">{{ question_data.choice_3 }}</label>
        </div>
        <div>
            <input type="radio" id="choice_4" name="answer" value="4">
            <label for="choice_4">{{ question_data.choice_4 }}</label>
        </div>
        <input type="hidden" id="time_elapsed" name="time_elapsed" value="0">
        <button type="submit">Submit</button>
    </form>
    <div style="position: fixed; bottom: 10px; left: 10px;">
        <p>Time remaining: <span id="timer">10</span> seconds</p>
    </div>
    <script>
        let timeRemaining = 10;
        const timerElement = document.getElementById('timer');
        const timeElapsedElement = document.getElementById('time_elapsed');

        function updateTimer() {
            if (timeRemaining > 0) {
                timeRemaining--;
                timerElement.textContent = timeRemaining;
            }
        }

        function setTimeElapsed() {
            timeElapsedElement.value = 10 - timeRemaining;
            return true;
        }

        setInterval(updateTimer, 1000);
    </script>
    """, question_data=question_data)

# Final score route
@app.route('/score', methods=['GET'])
def score():
    score = int(request.cookies.get('score', 0))
    return f"<h1>Your score: {score}/{len(quiz_data)}</h1>"

# Main function
def main():
    logger.info("Starting Flask app on 127.0.0.1:5000")
    app.run(host='127.0.0.1', port=5000)

if __name__ == '__main__':
    main()
