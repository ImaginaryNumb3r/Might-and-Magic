package misc;

import monster.Resistance;

import java.lang.invoke.MethodHandles;
import java.lang.invoke.VarHandle;
import java.lang.reflect.Field;
import java.lang.reflect.Modifier;
import java.lang.reflect.Type;
import java.util.*;
import java.util.function.BiFunction;
import java.util.function.Supplier;
import java.util.stream.Stream;

import static java.util.Arrays.asList;

/**
 * Creator: Patrick
 * Created: 01.05.2019
 * Purpose:
 */
public class FieldHandle {

    public static void setFields(Object instance, Map<String, Object> fieldMap){
        setFields(instance, fieldMap, FieldTransformer.identity);
    }

    public static void setFields(Object instance, Map<String, Object> fieldMap, FieldTransformer fieldTransformer ){
        Class<?> type = instance.getClass();
        HashMap<String, Class<?>> fields = new HashMap<>();
        Stream.of(type.getDeclaredFields()).forEach(field -> fields.put(field.getName(), field.getType()));

        try {
            MethodHandles.Lookup lookup = MethodHandles.lookup();
            for (var fieldEntry : fieldMap.entrySet()) {
                String fieldName = fieldEntry.getKey();
                Object newValue = fieldEntry.getValue();
                Class<?> fieldType = fields.get(fieldName);

                VarHandle handle = MethodHandles.privateLookupIn(type, lookup)
                        .findVarHandle(type, fieldName, fieldType);

                Object currentValue = handle.get(instance);
                var value = fieldTransformer.transform(fieldType, currentValue, newValue);
                boolean assignableFrom = fieldType.isAssignableFrom(value.getClass());
                if (!assignableFrom) {
                    System.out.println();
                }

                handle.set(instance, value);
            }
        } catch (ReflectiveOperationException e) {
            e.printStackTrace();
        }
    }

    public static void visitFields(Object instance, BiFunction<Type, Object, Object> visitor) {
        Class<?> type = instance.getClass();
        Field[] fields = type.getDeclaredFields();

        try {
            MethodHandles.Lookup lookup = MethodHandles.lookup();
            for (Field field : fields) {
                // Ignore static fields.
                if (Modifier.isStatic(field.getModifiers())) continue;

                VarHandle handle = MethodHandles.privateLookupIn(type, lookup)
                        .findVarHandle(type, field.getName(), field.getType());


                Object value = visitor.apply(field.getType(), handle.get(instance));
                handle.set(instance, value);
            }
        } catch (ReflectiveOperationException e) {
            e.printStackTrace();
        }
    }

    public static <T> List<Object> getFields(T instance) {
        Class<?> type = instance.getClass();
        Field[] fields = type.getDeclaredFields();
        ArrayList<Object> objects = new ArrayList<>();

        try {
            MethodHandles.Lookup lookup = MethodHandles.lookup();
            for (Field field : fields) {
                // Ignore static fields.
                if (Modifier.isStatic(field.getModifiers())) continue;

                VarHandle handle = MethodHandles.privateLookupIn(type, lookup)
                        .findVarHandle(type, field.getName(), field.getType());

                Object value = handle.get(instance);
                objects.add(value);
            }
        } catch (ReflectiveOperationException e) {
            e.printStackTrace();
        }

        return objects;
    }

    public static <T> T setFields(Object[] values, Supplier<T> constructor) {
        return setFields(asList(values), constructor);
    }

    public static <T> T setFields(List<Object> values, Supplier<T> constructor) {
        T instance = constructor.get();
        Class<?> targetType = instance.getClass();
        var fieldArray = targetType.getDeclaredFields();
        if (fieldArray.length < values.size()) throw new IllegalArgumentException();

        Iterator<Object> iterator = values.iterator();

            for (Field field : fieldArray) {
                if (Modifier.isStatic(field.getModifiers())) continue;
                if (!iterator.hasNext()) break;

                Object value = iterator.next();
                MethodHandles.Lookup lookup = MethodHandles.lookup();


                try {
                    value = convert(value, field.getType());

                    VarHandle handle = MethodHandles.privateLookupIn(targetType, lookup)
                            .findVarHandle(targetType, field.getName(), value.getClass());

                     /*
                     VarHandle handle2 = MethodHandles.privateLookupIn(targetType, lookup)
                            .findVarHandle(targetType, field.getName(), field.getClass());

                     VarHandle handle = MethodHandles.lookup()
                            .in(targetType)
                            .findVarHandle(targetType, field.getName(), value.getClass()); */

                    handle.set(instance, value);
                } catch (ReflectiveOperationException e) {
                    e.printStackTrace();
                }
            }

        return instance;
    }

    public static <T> List<VarHandle> ofClass(Class<T> type, Class<T> fieldType) {
        var fieldArray = type.getFields();
        var handles = new ArrayList<VarHandle>(fieldArray.length);

        try {
            for (Field field : fieldArray) {
                VarHandle handle = MethodHandles.lookup()
                        .in(type)
                        .findVarHandle(type, field.getName(), fieldType);

                handles.add(handle);
            }
        } catch (ReflectiveOperationException e) {
            e.printStackTrace();
        }

        return handles;
    }

    private static Object convert(Object object, Class<?> type) {
        if (type == String.class) {
            return String.valueOf(object);
        } else if (type == Integer.class) {
            return Integer.valueOf(object.toString());
        } else if (type == Resistance.class) {
            return Resistance.valueOf(object.toString());
        } else if (type == Boolean.class) {
            String str = object.toString().toLowerCase();
            return str.equals("y");
        }

        throw new UnsupportedOperationException();
    }
}
