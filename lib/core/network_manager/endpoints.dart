class EndPoints {
  static const getPosts = "/posts";
  static String getComments(int postId) => "/posts/$postId/comments";
  // POST https://api.cloudinary.com/v1_1/demo/image/upload
}
