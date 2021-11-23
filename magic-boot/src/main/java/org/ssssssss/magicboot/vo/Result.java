package org.ssssssss.magicboot.vo;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Result<T> {
    // 错误码
    private String code;
    // 提示信息
    private String msg;
    // 具体的内容
    private T data;
    // 是否成功
    private boolean success;
    // 总数
    private Long total;

    public Result() {
    }

    public Result(String code, String msg, T data, boolean success) {
        this.code = code;
        this.msg = msg;
        this.data = data;
        this.success = success;
    }

    public static<T> Result<T> isSuccess(T data) {
        Result<T> objectResult = new Result<T>();
        objectResult.setCode("200");
        objectResult.setSuccess(true);
        objectResult.setMsg("成功");
        objectResult.setData(data);
        return objectResult;
    }

    public static<T> Result<T> isSuccess(T data, Long count) {
        Result<T> objectResult = new Result<T>();
        objectResult.setCode("200");
        objectResult.setSuccess(true);
        objectResult.setMsg("成功");
        objectResult.setData(data);
        objectResult.setTotal(count);
        return objectResult;
    }

    public static<T> Result<T> isBad(T data) {
        Result<T> objectResult = new Result<T>();
        objectResult.setCode("400");
        objectResult.setSuccess(false);
        objectResult.setMsg("失败");
        objectResult.setData(data);
        return objectResult;
    }

    public static<T> Result<T> isBad(String msg) {
        Result<T> objectResult = new Result<>();
        objectResult.setCode("400");
        objectResult.setSuccess(false);
        objectResult.setMsg(msg);
        return objectResult;
    }

    public static<T> Result<T> isBad(String msg, String code) {
        Result<T> objectResult = new Result<T>();
        objectResult.setCode(code);
        objectResult.setSuccess(false);
        objectResult.setMsg(msg);
        return objectResult;
    }

    public static<T> Result<T> getResult(boolean isSuccess, T data) {
        if (isSuccess) {
            return Result.isSuccess(data);
        }
        return Result.isBad(data);
    }

    public static<T> Result<T> getResult(boolean isSuccess, T data, String msg) {
        if (isSuccess) {
            return Result.isSuccess(data);
        }
        return Result.isBad(msg);
    }

    public static<T> Result<T> getResult(boolean isSuccess, String msg) {
        if (isSuccess) {
            return Result.isSuccess(null);
        }
        return Result.isBad(msg);
    }

    public static<T> Result<T> getResult(boolean isSuccess, String msg, String code) {
        if (isSuccess) {
            return Result.isSuccess(null);
        }
        return Result.isBad(msg, code);
    }


    @Override
    public String toString() {
        return "Result{" +
                "code='" + code + '\'' +
                ", msg='" + msg + '\'' +
                ", data=" + data +
                ", success=" + success +
                '}';
    }
}
