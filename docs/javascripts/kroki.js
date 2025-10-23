// Kroki diagram rendering for PlantUML and other diagram types
(function() {
  const KROKI_SERVER = 'http://localhost:8001';
  
  function renderDiagram(element, diagramType) {
    const code = element.textContent;
    const url = `${KROKI_SERVER}/${diagramType}/svg`;
    
    fetch(url, {
      method: 'POST',
      headers: {
        'Content-Type': 'text/plain',
      },
      body: code
    })
    .then(response => response.text())
    .then(svg => {
      const wrapper = document.createElement('div');
      wrapper.className = 'kroki-diagram';
      wrapper.innerHTML = svg;
      element.parentElement.replaceWith(wrapper);
    })
    .catch(error => {
      console.error('Error rendering diagram:', error);
      element.parentElement.insertAdjacentHTML('beforebegin', 
        '<div class="admonition error"><p class="admonition-title">Diagram Rendering Error</p><p>Failed to render diagram. Check if Kroki service is running.</p></div>'
      );
    });
  }
  
  // Wait for page load
  document.addEventListener('DOMContentLoaded', function() {
    // Render PlantUML diagrams
    document.querySelectorAll('code.language-plantuml').forEach(element => {
      renderDiagram(element, 'plantuml');
    });
    
    // Render other diagram types if needed
    document.querySelectorAll('code.language-mermaid').forEach(element => {
      renderDiagram(element, 'mermaid');
    });
  });
})();
