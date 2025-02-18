db.createUser({
  user: 'appuser',
  pwd: 'apppassword123',
  roles: [
    {
      role: 'readWrite',
      db: 'qna_db'
    }
  ]
});

db = new Mongo().getDB("qna_db");

db.createCollection('questions');

db.questions.insertMany([
  {
    title: "Sample Question",
    content: "This is a sample question.",
    answers: []
  },
  {
    title: "Another Question",
    content: "This is another sample question.",
    answers: []
  }
]);

print("Initialized qna_db database with sample data.");
