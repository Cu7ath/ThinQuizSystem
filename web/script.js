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
window.onload = function () {
    let start = Date.now();
    const timerElement = document.getElementById("timer");

    setInterval(() => {
        let elapsed = Math.floor((Date.now() - start) / 1000);
        let hours = String(Math.floor(elapsed / 3600)).padStart(1, '0');
        let minutes = String(Math.floor((elapsed % 3600) / 60)).padStart(2, '0');
        let seconds = String(elapsed % 60).padStart(2, '0');
        timerElement.textContent = `${hours}:${minutes}:${seconds}`;
    }, 1000);
};