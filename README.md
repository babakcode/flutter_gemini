# Flutter Gemini

Google Gemini is a set of cutting-edge large language models (LLMs) designed to be the driving force behind Google's future AI initiatives.

![gemini_github_cover](https://github.com/babakcode/flutter_gemini/assets/31356659/104a436c-cc1e-4523-aeeb-edfb50f87346)

This package provides a powerful bridge between your Flutter application and Google's revolutionary Gemini AI. It empowers you to seamlessly integrate Gemini's capabilities into your app, unlocking possibilities for building innovative, intelligent, and engaging experiences that redefine user interaction.

## Features

- Set up your API key [scroll](#getting-started)
- Initialize Gemini [scroll](#initialize-gemini)
- Content-based APIs [scroll](#content-based-apis)
  - promptStream [scroll](#prompt-stream)
  - prompt [scroll](#prompt)
  - Multi-turn conversations (chat) [scroll](#multi-turn-conversations-chat)
  - Count tokens [scroll](#count-tokens)
  - Model info [scroll](#model-info)
  - List models [scroll](#list-models)
  - EmbedContents and batchEmbedContents [scroll](#embedcontents-and-batchembedcontents)
- Advanced Usage [scroll](#advanced-usage)
  - Safety settings [scroll](#safety-settings)
  - Generation configuration [scroll](#generation-configuration)
- Legacy APIs [scroll](#legacy-apis)
  - Stream Generate Content [scroll](#stream-generate-content)
  - Text-only input [scroll](#text-only-input)
  - Text-and-image input [scroll](#text-and-image-input)
    

## Getting started

To use the Gemini API, you'll need an API key. If you don't already have one, create a key in Google AI Studio. [Get an API key](https://ai.google.dev/).

[//]: # (### online demo)

[//]: # ()
[//]: # ([https://babakcode.github.io/flutter_gemini]&#40;https://babakcode.github.io/flutter_gemini&#41;)

## Initialize Gemini

For initialization, you must call the init constructor for Flutter Gemini in the main function.

```dart
const apiKey = '--- Your Gemini Api Key ---';

void main() {

  /// Add this line
  Gemini.init(apiKey: apiKey);

  runApp(const MyApp());
}
```

Now you can create an instance

## Content-based APIs

### Prompt Stream

Offers a powerful method `promptStream` that allows developers to interact with
a stream of data in a flexible and efficient way. One of the key features of this package is
the ability to use different types of `Part` classes,
enabling the transmission of various forms of data.

**Usage Example**
To use the promptStream method, you can pass an array of Part objects, where each Part can represent different types of data. For instance, a simple request to ask a question could look like this:

```dart
Gemini.instance.promptStream(parts: [
  Part.text('Write a story about a magic backpack'),
]).listen((value) {
  print(value?.output);
});
```

#### Available Part Types

1. `Part.text` | `TextPart`: For sending text data.
2. `Part.inline` | `InlinePart`: For sending raw byte data.
3. `Part.file` | `FilePart`: For sending uploaded file to Gemini cloud ( will be updated )
4. ...
5. ( Others will be added ASAP )

These `Part` types are abstracted into a base class, providing flexibility to add more data types in the future. This modular design ensures that users can easily extend the package to accommodate their specific needs, whether it's for text, files, or binary data.

By using these different `Part` classes, you can tailor the behavior of the `promptStream` method to meet your application's specific requirements.

### Prompt

You can send a question or request and get an immediate response using the `prompt` method. This method works with various `Part` types to allow flexible input, such as text, videos, or audios.

**Usage Example**

The following example shows how to use the `Flutter_Gemini` package with the `Future` approach to send a text request and handle the response:

```dart
Gemini.instance.prompt(parts: [
  Part.text('Write a story about a magic backpack'),
]).then((value) {
  print(value?.output);
}).catchError((e) {
  print('error ${e}');
});
```

*Explanation*:

* The `prompt` method takes a list of `Part` objects, such as `Part.text` ( `TextPart` ), to define the request.
* The response is processed once it is available, and you can access the result via value?.output.
* Errors can be handled using catchError.


This method provides a straightforward way to handle asynchronous tasks without dealing with streams.

#### Multi-turn conversations (chat)

Using Gemini, you can build freeform conversations across multiple turns.

```dart
  final gemini = Gemini.instance;

  gemini.chat([
    Content(parts: [
      Part.text('Write the first line of a story about a magic backpack.')],
        role: 'user'),
    Content(parts: [ 
      Part.text('In the bustling city of Meadow brook, lived a young girl named Sophie. She was a bright and curious soul with an imaginative mind.')],
        role: 'model'),
    Content(parts: [ 
      Part.text('Can you set it in a quiet village in 1600s France?')], 
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

## Advanced Usage

The following sections discuss advanced use cases and lower-level details of the Flutter SDK for the Gemini API.

#### Safety settings

The `safety_settings` argument lets you configure what the model blocks and allows in both prompts and responses.

```dart
gemini.streamGenerateContent('Utilizing Google Ads in Flutter',
          safetySettings: [
            SafetySetting(
              category: SafetyCategory.harassment,
              threshold: SafetyThreshold.blockLowAndAbove,
            ),
            SafetySetting(
              category: SafetyCategory.hateSpeech,
              threshold: SafetyThreshold.blockOnlyHigh,
            )
          ])
        .listen((value) {})
        .onError((e) {});
```

#### Generation configuration

The `generation_config` argument allows you to modify the generation parameters.

```dart
gemini.streamGenerateContent('Utilizing Google Ads in Flutter',
          generationConfig: GenerationConfig(
            temperature: 0.75,
            maxOutputTokens: 512,
          ))
      .listen((value) {})
      .onError((e) {});
```

## Legacy APIs


#### Stream Generate Content

The model usually gives a response once it finishes generating the entire output. To speed up interactions, you can opt not to wait for the complete result and instead use streaming to manage partial results.

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
![Flutter Gemini stream](https://github.com/babakcode/flutter_gemini/assets/31356659/cabe2392-d584-4bbb-b5a9-a86db6b2d7f1)

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

If the input contains both text and image, You can send a text prompt with an image to the gemini-1.5-flash model to perform a vision-related task. For example, captioning an image or identifying what's in an image.

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
