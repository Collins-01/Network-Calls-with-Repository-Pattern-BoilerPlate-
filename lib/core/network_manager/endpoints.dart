class EndPoints {
  static const getPosts = "/posts";
  static String getComments(int postId) => "/posts/$postId/comments";
  // https://jsonplaceholder.typicode.com/posts/1/comments
}
