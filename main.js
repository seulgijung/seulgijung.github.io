
const images = document.querySelectorAll('.carousel-img'); // querySelectorAll returns a list of all matching elements
const leftArrow = document.querySelector('.arrow.left');    // querySelector returns the first thing that matches the key
const rightArrow = document.querySelector('.arrow.right');      // semi colon is optional
let current = 0;        // a variable to help remember in what ordinal number the current image being seen. the first image appears as the page opens, therefore set up as zero. to track numbers change, needs a variable to store in what ordinal number it is now, no matter what name of the variable takes. whether it is carousel, tap, or quiz.

function updateCarousel() {
  images.forEach(img => img.classList.remove('active'));        // => means an arrow function (abbreviated function); img is an arbitrary random name of function here, it works the same way when you call it potato; img is like a parameter A in for-A-in-B in python
  images[current].classList.add('active');      // .classList = a method to use in check(.contain = boolean type), add, or remove `class`; simply (de)attaching `active` decides whether an image displays since only `.carousel-img.active` = `display: block` in CSS; images[current] = images[0] = first cat photo displaying —> list grammar

  leftArrow.style.display = current === 0 ? 'none' : 'block';   // leftArrow
  rightArrow.style.display = current === images.length - 1 ? 'none' : 'block';
}

leftArrow.addEventListener('click', () => {     
  current--;
  updateCarousel();
});

rightArrow.addEventListener('click', () => {
  current++;
  updateCarousel();
});

updateCarousel();       // imply the function w/o any trigger, displaying the first image, hide < button, and displaying > button all because current = 0; w/t this, < button is visible despite the first image; in a nutshell, it triggers the inital setup.