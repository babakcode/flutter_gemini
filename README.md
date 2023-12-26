# Flutter Gemini

Google Gemini is a set of cutting-edge large language models (LLMs) designed to be the driving force behind Google's future AI initiatives.

![gemini_github_cover](https://github.com/babakcode/flutter_gemini/assets/31356659/104a436c-cc1e-4523-aeeb-edfb50f87346)

This package provides a powerful bridge between your Flutter application and Google's revolutionary Gemini AI. It empowers you to seamlessly integrate Gemini's capabilities into your app, unlocking possibilities for building innovative, intelligent, and engaging experiences that redefine user interaction.

## Features

- Set up your API key [scroll](#getting-started)
- Initialize Gemini [scroll](#initialize-gemini)
- Content-based APIs [scroll](#content-based-apis)
  - Stream generate content [scroll](#stream-generate-content)
  - Text-only input [scroll](#text-only-input)
  - Text-and-image input [scroll](#text-and-image-input)
  - Multi-turn conversations (chat) [scroll](#multi-turn-conversations-chat)
  - Count tokens [scroll](#count-tokens)
  - Model info [scroll](#model-info)
  - List models [scroll](#list-models)
  - EmbedContents and batchEmbedContents [scroll](#embedcontents-and-batchembedcontents)
- Flutter Gemini widgets [scroll](#flutter-gemini-widgets)
    

## Getting started

To use the Gemini API, you'll need an API key. If you don't already have one, create a key in Google AI Studio. [Get an API key](https://ai.google.dev/).

### online demo

[https://babakcode.github.io/flutter_gemini](https://babakcode.github.io/flutter_gemini)

## Initialize Gemini

For initialization, you must call the init constructor for Flutter Gemini in the main function.

```dart
void main() {

  /// Add this line
  Gemini.init(apiKey: '--- Your Gemini Api Key ---');

  runApp(const MyApp());
}
```

Now you can create an instance

## Content-based APIs

#### Stream generate content

The model usually gives a response once it finishes generating the entire output. To speed up interactions, you can opt to not wait for the complete result and, instead, use streaming to manage partial results.

```dart
final gemini = Gemini.instance;

gemini.streamGenerateContent('Utilizing Google Ads in Flutter')
  .listen((value) {
    print(value.output);
  }).onError((e) {
    log('streamGenerateContent exception', error: e);
  });
```
![Flutter gemini stream generates content](https://github.com/babakcode/flutter_gemini/assets/31356659/0a6f6eaa-684c-4708-b395-16176c7b0180)



#### Text-only input

This feature lets you perform natural language processing (NLP) tasks such as text completion and summarization.

```dart
final gemini = Gemini.instance;

gemini.text("Write a story about a magic backpack.")
  .then((value) => print( value?.output )) /// or value?.content?.parts?.last.text
  .catchError((e) => print(e));
```

![Flutter gemini Text only example gif](https://miro.medium.com/v2/resize:fit:828/format:webp/1*41dnttHItU2v4hobJ_DGSA.gif "Flutter_Gemini example")

#### Text-and-image input

If the input contains both text and image, You can send a text prompt with an image to the gemini-pro-vision model to perform a vision-related task. For example, captioning an image or identifying what's in an image.

```dart
  final gemini = Gemini.instance;

  final file = File('assets/img.png');
  gemini.textAndImage(
        text: "What is this picture?", /// text
        images: [file.readAsBytesSync()] /// list of images
      )
      .then((value) => log(value?.content?.parts?.last.text ?? ''))
      .catchError((e) => log('textAndImageInput', error: e));
```

###### Note that, there are changes on properties

```diff
- image: file.readAsBytesSync(), /// image
+ images: [file.readAsBytesSync()] /// list of images
```

![Flutter gemini Text and Image example gif](https://miro.medium.com/v2/resize:fit:828/format:webp/1*3JEeJaBRSpif6hOl2pt3RA.gif "Flutter_Gemini example")


#### Multi-turn conversations (chat)

Using Gemini, you can build freeform conversations across multiple turns.

```dart
  final gemini = Gemini.instance;

  gemini.chat([
    Content(parts: [
      Parts(text: 'Write the first line of a story about a magic backpack.')],
        role: 'user'),
    Content(parts: [ 
      Parts(text: 'In the bustling city of Meadow brook, lived a young girl named Sophie. She was a bright and curious soul with an imaginative mind.')],
        role: 'model'),
    Content(parts: [ 
      Parts(text: 'Can you set it in a quiet village in 1600s France?')], 
        role: 'user'),
    ])
        .then((value) => log(value?.output ?? 'without output'))
        .catchError((e) => log('chat', error: e));
```


![Flutter gemini Text and Image example gif](https://miro.medium.com/v2/resize:fit:828/format:webp/1*MoVz4Z5KpxVUocEHLmzDew.gif "Flutter_Gemini example")


#### Count tokens

When using long prompts, it might be useful to count tokens before sending any content to the model.

```dart
final gemini = Gemini.instance;

gemini.countTokens("Write a story about a magic backpack.")
    .then((value) => print(value)) /// output like: `6` or `null`
    .catchError((e) => log('countTokens', error: e));
```

#### Model info

If you `GET` a model's URL, the API uses the `get` method to return information about that model such as version, display name, input token limit, etc.

```dart
final gemini = Gemini.instance;

gemini.info(model: 'gemini-pro')
    .then((info) => print(info))
    .catchError((e) => log('info', error: e));
```

#### List models

If you `GET` the `models` directory, it uses the `list` method to list all of the models available through the API, including both the Gemini and PaLM family models.

```dart
final gemini = Gemini.instance;

gemini.listModels()
    .then((models) => print(models)) /// list
    .catchError((e) => log('listModels', error: e));
```

#### embedContents and batchEmbedContents

Embedding is a method that transforms information, like text, into a list of floating-point numbers in an array. Gemini enables the representation of text, such as words or sentences, in a vectorized form. This facilitates the comparison of embeddings, allowing for the identification of similarities between texts through mathematical techniques like cosine similarity. For instance, texts with similar subject matter or sentiment should exhibit similar embeddings.

```dart
/// `embedContents`
gemini.embedContent('text').then((value) {
  print(value); /// output like: [ 1.3231, 1.33421, -0.123123 ]
});

/// `batchEmbedContents`
gemini.batchEmbedContents(['text 1', 'text 2']).then((value) {
  print(value); /// output like: [ [ 1.3231, 1.33421, -0.123123 ] ]
});
```

## Flutter Gemini Widgets

The `GeminiResponseTypeView` widget allows you to present your search results using a **`typing`** animation, all **`without`** the need for utilizing the **`setState()`** function!

```dart
final Widget result = GeminiResponseTypeView(
  builder: (context, child, response, loading) {

    if (loading) {
      /// show loading animation or use CircularProgressIndicator();
      return Lottie.asset('assets/lottie/ai.json');
    }

    /// The runtimeType of response is String?
    if (response != null) {
      return Markdown(
        data: response,
        selectable: true,
      );
    } else {
      
      /// idle state
      return const Center(child: Text('Search something!'));
    }
  },
);
```
