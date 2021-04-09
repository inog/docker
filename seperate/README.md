
#Separating build and runtime environment using multi-stage builds

In this tutorial we will learn how to create smaller images by separating the build environment from the runtime environment.
Setting up the environment

To demonstrate the difference between the build environment and the runtime environment, we will use a hello world program written in Java. The following command create HelloWorld.java which we will use throughout this tutorial:

    cat >HelloWorld.java <<EOF
    class HelloWorld {
        public static void main(String[] a) {
            System.out.println("Hello world!");
        }
    }
    EOF

## Mixing build and runtime environments

The straight forward way of building and packaging the Java program is by using the Java Development Kit (JDK). Consider the following Dockerfile:

    cat >Dockerfile <<EOF
    FROM openjdk:11-jdk
    COPY HelloWorld.java .
    RUN javac HelloWorld.java
    CMD java HelloWorld
    EOF

When building it, the resulting image will contain the JDK, the source code and the compiled hello world program:

    docker image build --tag helloworld:huge .

Although it produces the correct output…

    docker container run helloworld:huge

…it is much to large because running the compiled program only requires the Java Runtime Environment (JRE) which is much smaller then the JDK. In addition, it is not necessary to ship the source code to execute the program.

In the end, the resulting image will be north of 600MB:

    docker image ls

## Separate environments for build and runtime

Separating the build environment allows for much smaller images because the runtime environment usually required much less space.

The following command will build our hello world program and place the compiled binary HelloWorld.class next to the source code:

    docker container run --volume $PWD:/src --workdir /src openjdk:11-jdk javac *.java

Using a simplified Dockerfile, the compiled program is added to the JRE image of OpenJDK:

    cat >Dockerfile <<EOF
    FROM openjdk:11-jre
    COPY HelloWorld.class .
    CMD java HelloWorld
    EOF

This time, the resulting image will not contain the source code…

    docker image build --tag helloworld:run .

…still produce the same output…

    docker container run helloworld:run

…and stay below 300MB in size:

    docker image ls

## Enter multi-stage builds

We can also combine the above approach of builing the program using the JDK and packaging it using the JRE in a single Dockerfile using the multi-stage build feature.

Each stage begins with a FROM statement and is named using the AS keyword. When building such a multi-stage Dockerfile, only the last stage describes the final image and its contents.

The following Dockerfile describes a multi-stage build for the hello world program used above:

    cat >Dockerfile <<EOF
    FROM openjdk:11-jdk AS build
    COPY HelloWorld.java .
    RUN javac HelloWorld.java

    FROM openjdk:11-jre AS run
    COPY --from=build HelloWorld.class .
    CMD java HelloWorld
    EOF

Using the above example, building the Java program is performed in the first stage using the JDK image. The second (and last) stage is based on the JRE image and copies the compiled program from the first stage. Note the new syntax for the COPY statement where it takes a parameter called --from specifying the build stage to copy from.

Building the image looks very similar to the well-known process:

    docker image build --tag helloworld:small .

The resulting image will work as expected…

    docker container run helloworld:small

…but have the same small size as above:

    docker image ls
