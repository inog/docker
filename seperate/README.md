
Separating build and runtime environment using multi-stage builds

In this tutorial we will learn how to create smaller images by separating the build environment from the runtime environment.
Setting up the environment

To demonstrate the difference between the build environment and the runtime environment, we will use a hello world program written in Java. The following command create HelloWorld.java which we will use throughout this tutorial:

cat >HelloWorld.java <<EOF
class HelloWorld {
    public static void main(String[] a) {
        System.out.println("Hello world!");
    }
}
