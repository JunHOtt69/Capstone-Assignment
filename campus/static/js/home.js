function copyCode(btn) {
    const container = btn.closest(".code-container");
    
    const codeElement = container.querySelector("code");
    const codeText = codeElement.innerText;
    
    navigator.clipboard.writeText(codeText).then(() => {
        const originalHTML = btn.innerHTML;
        
        btn.innerHTML = `<span class="copyIcon">Copied!</span>`;
        
        setTimeout(() => {
            btn.innerHTML = originalHTML;
        }, 2000);
    }).catch(err => {
        console.error('Failed to copy: ', err);
    });
}