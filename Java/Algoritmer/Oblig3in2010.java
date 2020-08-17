package oblig3in2010;
import java.util.*;
import java.io.*;
import java.lang.reflect.Array;


public class Oblig3in2010 {
    public static int keys=10000000;
    public static int[] k=new int[20];
    
    public static void main(String[] args) {
        //test(); //Validation and pattern
        
        for(int i=0;i<k.length;i++){
            k[i]=i*5000;
        }
        
        TestTid t=new TestTid(k);
        t.printTable();
        
    }
    
    public static void test(){
        int[] a = new int[10];
        int[] b = new int[10];
        int[] c = new int[10];
        int[] ccopy= new int[10];
        
        a=randarr(a.length);
        
        for(int i=0;i<b.length;i++){
            b[i]=i;
        }
        c=setC(c);
        
        System.out.print("Unsorted: ");
        printarr(a);
        printarr(b);
        printarr(c);
        System.out.println();
        System.out.print("Sorting: ");
        selectionSort(a);
        selectionSort(b);
        selectionSort(c);
        System.out.println();
        System.out.print("Sorted Selection: ");
        printarr(a);
        printarr(b);
        printarr(c);
        
        a=randarr(a.length);
        c=setC(c);
        System.out.print("Unsorted: ");
        printarr(a);
        printarr(b);
        printarr(c);
        System.out.println();
        System.out.print("Sorting: ");
        insertionSort(a);
        insertionSort(b);
        insertionSort(c);
        System.out.println();
        System.out.print("Insert: ");
        printarr(a);
        printarr(b);
        printarr(c);
        
        a=randarr(a.length);
        c=setC(c);
        System.out.print("Unsorted: ");
        printarr(a);
        printarr(b);
        printarr(c);
        System.out.println();
        System.out.print("Sorting: ");
        quickSort(a);
        quickSort(b);
        quickSort(c);
        System.out.println();
        System.out.print("Quicksort: ");
        printarr(a);
        printarr(b);
        printarr(c);
        
        a=randarr(a.length);
        c=setC(c);
        System.out.print("Unsorted: ");
        printarr(a);
        printarr(b);
        printarr(c);
        System.out.println();
        System.out.print("Sorting: ");
        bucketSort(a);
        bucketSort(b);
        bucketSort(c);
        System.out.println();
        System.out.print("Bucket: ");
        printarr(a);
        printarr(b);
        printarr(c);
    }
    public static int[] selectionSort(int[] arr){
        System.out.println();
        for(int j=0;j<arr.length;j++){
            int x=arr[j];
            int dex=j;
            for(int i=j;i<arr.length;i++){
                if(arr[i]<x){
                    x=arr[i];
                    dex=i;
                }
            }
            int a=arr[j];
            arr[j]=arr[dex];
            arr[dex]=a;
            
            System.out.println();
            for(int k:arr){
            System.out.print(k);
            }
        }
        return arr;
    }
    
    public static int[] insertionSort(int[] arr){
        System.out.println();
        for(int i=1;i<arr.length;i++){
            int x=arr[i];
            int j=i;
            while(j>0 && x<arr[j-1]){ 
                arr[j]=arr[j-1];
                j--;
            }
            arr[j]=x;
            
            System.out.println();
            for(int k:arr){
            System.out.print(k);
            }
        }
        return arr;
    }
    
    public static int[] quickSort(int[] arr){
        System.out.println();
        inPlaceQuickSort(arr,0,arr.length-1);
        return arr;
    }
    
    public static void inPlaceQuickSort(int[] arr, int a, int b){
        if(a<b){
            int l= inPlacePartition(arr,a,b);
            
            System.out.println();
            for(int k:arr){
            System.out.print(k);
            }
            
            inPlaceQuickSort(arr,a,l-1);
            inPlaceQuickSort(arr,l+1,b);
        }

        
        
    }
    
    public static int inPlacePartition(int[] arr, int a, int b){
        int r=(int)Math.floor((b-a)/2+a);
        int c=arr[r];
        arr[r]=arr[b];
        arr[b]=c;
        int p=arr[b];
        int l = a;
        r = b-1;
        while(l<=r){
            while(l<=r && arr[l]<=p){
                l=l+1;}
            while(r>=l && arr[r]>=p){
                r=r-1;}
            if(l<r){
                int d=arr[l];
                arr[l]=arr[r];
                arr[r]=d;
            }
        }
        int e=arr[l];
        arr[l]=arr[b];
        arr[b]=e;
        return l;
    }
    
    public static int[] bucketSort(int[] arr){ 
        ArrayList[] buckets=new ArrayList[keys];
        ArrayList barr=new ArrayList();
        for(int x=0;x<keys;x++){
            buckets[x]=new ArrayList();
        }
        for(int x=0;x<arr.length;x++){
            buckets[arr[x]].add(arr[x]);
            arr[x]=0;
        }
        System.out.println();
        for(int i=0;i<keys;i++){
            for(Object x:buckets[i]){
                barr.add((int)x);
                System.out.print((int)x);
            }
            System.out.print(" ");
        }
        for(int i=0;i<barr.size();i++){
            arr[i]=(int)barr.get(i);
        }
        return arr;
    }
    
    public static void printarr(int[] a){
        System.out.println();
        for(int i:a){
            System.out.print(i);
        }
    }
    public static int[] randarr(int a){
        System.out.println();
        System.out.println();
        int[] b=new int[a];
        for(int i=0;i<a;i++){
            b[i]=(int)(Math.random()*keys);
        }
        return b;
    }
    
    public static int[] setC(int[] c){
        for(int i=0;i<c.length;i++){
            c[i]=c.length-1-i;
        }
        return c;
    }
}
