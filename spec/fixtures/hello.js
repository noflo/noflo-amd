define(function (require, exports, module) {
  return function (arg) {
    return module.config().greeting + ' ' + arg;
  };
});
