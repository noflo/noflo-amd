define(['fixtures/hello.js'], function (hello) {
  return function (arg) {
    return hello(arg);
  };
});
