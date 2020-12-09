package com.lcw.crm.vo;

import java.util.List;
import java.util.Objects;

public class PaginationVO<E>{
    private long total;
    private List<E> dataList;
    private int totalPages;

    public int getTotalPages() {
        return totalPages;
    }

    public void setTotalPages(int totalPages) {
        this.totalPages = totalPages;
    }

    public long getTotal() {
        return total;
    }

    public void setTotal(long total) {
        this.total = total;
    }

    public List<E> getDataList() {
        return dataList;
    }

    public void setDataList(List<E> dataList) {
        this.dataList = dataList;
    }

    public PaginationVO() {
    }

    @Override
    public String toString() {
        return "PaginationVO{" +
                "total=" + total +
                ", dataList=" + dataList +
                ", totalPages=" + totalPages +
                '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        PaginationVO<?> that = (PaginationVO<?>) o;
        return total == that.total &&
                totalPages == that.totalPages &&
                Objects.equals(dataList, that.dataList);
    }


}
