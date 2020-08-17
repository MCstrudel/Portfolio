package oblig3in2010;

import java.util.ArrayList;
import static oblig3in2010.Oblig3in2010.keys;

public class TestTid {
    private static double[][] table;
    private int[] elem;
    
    public TestTid(int[] e){
        elem=e;
        table=new double[elem.length][];
        
        for(int x=0;x<elem.length;x++){
            table[x]=tid(elem[x]);
        }
    }
    
    public void printTable(){
        System.out.println("elements   java.sort()   selection    insertion      quick       bucket");
        for (int row = 0; row < table.length; row++) {
            System.out.printf("%5d", elem[row]);
            for (int col = 0; col < 5; col++) {
                System.out.printf("%13.2f", table[row][col]);
            }
            System.out.println();
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
    
    public static double[] tid(int elementer){
        double[] tider=new double[5];
        int[] a=new int[elementer];
        
        a=randarr(a.length);
        long t = System.nanoTime();
        javaSort(a);
        tider[0]=(System.nanoTime()-t)/10000000.0; 
        
        a=randarr(a.length);
        t = System.nanoTime();
        selectionSort(a);
        tider[1]=(System.nanoTime()-t)/10000000.0; 
        
        a=randarr(a.length);
        t = System.nanoTime();
        insertionSort(a);
        tider[2]=(System.nanoTime()-t)/10000000.0;
        
        a=randarr(a.length);
        t = System.nanoTime();
        quickSort(a);
        tider[3]=(System.nanoTime()-t)/10000000.0;
        
        a=randarr(a.length);
        t = System.nanoTime();
        bucketSort(a);
        tider[4]=(System.nanoTime()-t)/10000000.0; 
        
        return tider;
    }
    
    public static int[] javaSort(int[] arr){
        java.util.Arrays.sort(arr);
        return arr;
    }
    
    public static int[] selectionSort(int[] arr){
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

        }
        return arr;
    }
    
    public static int[] insertionSort(int[] arr){
        for(int i=1;i<arr.length;i++){
            int x=arr[i];
            int j=i;
            while(j>0 && x<arr[j-1]){ 
                arr[j]=arr[j-1];
                j--;
            }
            arr[j]=x;
        }
        return arr;
    }
    
    public static int[] quickSort(int[] arr){
        inPlaceQuickSort(arr,0,arr.length-1);
        return arr;
    }
    
    public static void inPlaceQuickSort(int[] arr, int a, int b){
        if(a<b){
            int l= inPlacePartition(arr,a,b);
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
        for(int i=0;i<keys;i++){
            for(Object x:buckets[i]){
                barr.add((int)x);
            }
        }
        for(int i=0;i<barr.size();i++){
            arr[i]=(int)barr.get(i);
        }
        return arr;
    }
}
