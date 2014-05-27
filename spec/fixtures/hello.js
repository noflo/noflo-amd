define(['module'], function (module) {
  return function (arg) {
    return module.config().greeting + ' ' + arg;
  };
});
