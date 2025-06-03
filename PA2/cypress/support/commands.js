Cypress.Commands.add('login', () => {
    cy.visit('http://localhost:8000/login');
    cy.get('input[name="email"]').type('admin@example.com');
    cy.get('input[name="password"]').type('password123');
    cy.get('button').contains('Log in').click();
  
    // Tunggu redirect selesai
    cy.url().should('not.include', '/login');
  });
  