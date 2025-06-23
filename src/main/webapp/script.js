/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */


// Dummy functions for demo
function deleteQuestion() {
    alert("Delete function clicked.");
}

function editQuestion() {
    alert("Edit function clicked.");
}

// Timer function (optional, static display only in wireframe)
// Countdown Timer untuk kuiz

window.onload = function () {
    let timerElement = document.getElementById("timer");

    // Ambil nilai masa dari elemen HTML (diset oleh JSP)
    let timeLeft = parseInt(document.getElementById("timer").getAttribute("data-timeleft"));

    function startCountdown(duration, display) {
        let timer = duration;
        let interval = setInterval(function () {
            let minutes = parseInt(timer / 60, 10);
            let seconds = parseInt(timer % 60, 10);

            display.textContent = minutes + "m " + seconds + "s";

            if (--timer < 0) {
                clearInterval(interval);
                alert("Masa tamat! Jawapan anda akan dihantar.");
                document.getElementById("quizForm").submit(); // auto submit form
            }
        }, 1000);
    }

    startCountdown(timeLeft, timerElement);
};